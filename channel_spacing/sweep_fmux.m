clear; clc;
sim.Nsymb = 1e6;
sim.Mct = 9;
sim.Rs = 56e9;
sim.M = 4;
sim.fm = 60e9;

snr_vec_dB = linspace(8, 12, 10);
snr_vec = 10.^(snr_vec_dB/10);

fmux_vec = [90 85 80 75 60]*1e9;

figure();
for i=1:length(fmux_vec)
    rng(12);
    main_sim = Simulation(sim);
    main_sim.fm = sim.fm;
    main_sim.fmux = fmux_vec(i);
    
    fprintf('Simulating %.1f-GHz MUX spacing ...\n', fmux_vec(i)/1e9);
    
    [snr, ber] = main_sim.simulate(snr_vec);

    semilogy(10*log10(snr), ber, 'DisplayName', strcat('f_{mux} = ', num2str(main_sim.fmux/1e9), ' GHz')); hold on;
end
legend(); grid(); xlabel('SNR (dB)'); ylabel('BER'); title(strcat('f_{m} = ', num2str(sim.fm/1e9), ' GHz'));