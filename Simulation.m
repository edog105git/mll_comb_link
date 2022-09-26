classdef Simulation
    properties
        % Simulation parameters
        Nsymb         % number of symbols
        Mct           % oversampling ratio to simulate CT
        M             % constellation size
        Rs            % symbol rate
        fs            % sampling rate
        t             % simulation time vector
        f             % simulation frequency vector
        SNR           % SNR per symbol
        fm            % channel and AWG spacing
        % Signal parameters
        b_n           % 3xNsymb unencoded data stream (b_n(2, :) - channel 0 data)
        x_n           % 3xNsymb encoded data stream
        x_t           % 3x(Nsymb*Mct) encoded signal
        s_t           % 1x(Nsymb*Mct) multiplexed signal
        y_t           % 1x(Nsymb*Mct) demultiplexed signal on central channel
        r_t           % 1x(Nsymb*Mct) detected signal on central channel
        r_n           % 1xNsymb sampled & decoded data on central channel
    end
    
    methods
        function obj = Simulation(sim)
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            obj.Nsymb = sim.Nsymb;
            obj.Mct = sim.Mct;
            obj.Rs = sim.Rs;
            obj.fs = sim.Rs*sim.Mct;
            obj.M = sim.M;
            
            obj.t = linspace(0, obj.Nsymb/obj.Rs, obj.Nsymb*obj.Mct);
            obj.f = linspace(-obj.fs/2, obj.fs/2, obj.Nsymb*obj.Mct);
        end
        
        function obj = generate_data(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.b_n = randi([0 3], 3, obj.Nsymb);
            obj.x_n = qammod(obj.b_n, obj.M, 'gray');
        end

        function obj = mux(obj)
            MuxFilter = AnalogFilter('super-gaussian', 3, obj.fm);
            xfilt_t = zeros(size(obj.x_t));             

            xfilt_t(1, :) = MuxFilter.filter(real(obj.x_t(1, :)), obj.fs, true) ...
                + 1j*MuxFilter.filter(imag(obj.x_t(1, :)), obj.fm, true);
            xfilt_t(2, :) = MuxFilter.filter(real(obj.x_t(2, :)), obj.fs, true) ...
                + 1j*MuxFilter.filter(imag(obj.x_t(2, :)), obj.fs, true);
            xfilt_t(3, :) = MuxFilter.filter(real(obj.x_t(2, :)), obj.fs, true) ...
                + 1j*MuxFilter.filter(imag(obj.x_t(2, :)), obj.fs, true);

            xm_t = xfilt_t(1, :).*exp(1j*2*pi*(-obj.fm)*obj.t);
            xc_t = xfilt_t(2, :);
            xp_t = xfilt_t(3, :).*exp(1j*2*pi*(obj.fm)*obj.t);

            obj.s_t = xm_t + xc_t + xp_t;
        end

        function obj = demux_central(obj)
            DemuxFilter = AnalogFilter('super-gaussian', 3, obj.fm);
            obj.y_t = DemuxFilter.filter(real(obj.s_t), obj.fs, true) ...
                + 1j*DemuxFilter.filter(imag(obj.s_t), obj.fs, true);
        end
        
        function obj = transmit(obj)
            obj = obj.generate_data();
            obj.x_t = repelem(obj.x_n, 1, obj.Mct);
            
            % Ref. Tx
            TxFilter = AnalogFilter('bessel', 5, 0.7*obj.Rs);

            xf_t = zeros(size(obj.x_t));
            xf_t(1, :) = TxFilter.filter(real(obj.x_t(1, :)), obj.fs, false) ...
                + 1j*TxFilter.filter(imag(obj.x_t(1, :)), obj.fs, false);
            xf_t(2, :) = TxFilter.filter(real(obj.x_t(2, :)), obj.fs, false) ...
                + 1j*TxFilter.filter(imag(obj.x_t(2, :)), obj.fs, false);
            xf_t(3, :) = TxFilter.filter(real(obj.x_t(3, :)), obj.fs, false) ...
                + 1j*TxFilter.filter(imag(obj.x_t(3, :)), obj.fs, false);
            
            % (Remove GD effects)
            [c, ind] = xcorr(obj.x_t(2, :), xf_t(2, :));
            [~, p] = max(abs(c));
            obj.x_t = circshift(xf_t, ind(p), 2);

            % Multiplex
            obj = obj.mux();
        end

        function obj = receive(obj)
            % De-multiplex
            obj = obj.demux_central();

            % LPF & add noise
            rI_t = real(obj.y_t); rQ_t = imag(obj.y_t);
            nI_t = sqrt(1e-12*obj.fs)*randn(size(rI_t));
            nQ_t = sqrt(1e-12*obj.fs)*randn(size(rQ_t));
            
            RxFilter = AnalogFilter('bessel', 5, 0.7*obj.Rs);
            rI_t = RxFilter.filter(rI_t, obj.fs, false);
            rQ_t = RxFilter.filter(rQ_t, obj.fs, false);
            nI_t = RxFilter.filter(nI_t, obj.fs, false);
            nQ_t = RxFilter.filter(nQ_t, obj.fs, false);

            T = obj.t(end) - obj.t(1);
            Psignal = trapz(obj.t, abs(rI_t + 1j*rQ_t).^2)/T;
            Pnoise = var(nI_t + 1j*nQ_t);

            a = obj.SNR/(Psignal/Pnoise);
            nI_t = sqrt(1/a)*nI_t; nQ_t = sqrt(1/a)*nQ_t;

            obj.r_t = (rI_t + nI_t) + 1j*(rQ_t + nQ_t);

            % Align
            [c, ind] = xcorr(obj.x_t(2, :), obj.r_t);
            [~, p] = max(abs(c));
            obj.r_t = circshift(obj.r_t, ind(p));

            % Sample & decode
            k = ceil(obj.Mct/2);
            obj.r_n = obj.r_t(k:obj.Mct:end);
            obj.r_n = qamdemod(obj.r_n, obj.M, 'gray');
        end

        function ber = count_BER(obj)
            [~, ber] = biterr(obj.b_n(2, :), obj.r_n);
        end

        function [snr, ber] = simulate(obj, snr_vec)
            obj = obj.transmit();
            
            ber = zeros(size(snr_vec));
            for i=1:length(snr_vec)
                obj.SNR = snr_vec(i);
                obj = obj.receive();
                ber(i) = obj.count_BER();
            end
            snr = snr_vec;
        end
    end
end