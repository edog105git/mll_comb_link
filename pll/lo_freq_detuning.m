clear; clc;
%% 0. Parameters
M = 4;                                    % constellation size
T_s = 1/56e9;                             % symbol interval
T_samp = T_s/1;                           % CT sim interval (s)
Ntot = 1e6;                               % total CT waveform points
gamma_s_dB = 10.8;                        % bit SNR (dB)
Deltamu = 2e6;                            % beat laser linewidth (Hz)
zeta = 1/sqrt(2);

var_phi = 2*pi*Deltamu*T_samp;            % phase noise "variance"
gamma_s = 10^(gamma_s_dB/10);             % symbol SNR (W/W)
eta_c = compute_eta_c(qammod(0:M-1, M));  % constellation penalty factor (should be 1)
Sww = (eta_c/2)*(T_s/gamma_s);
var_w = Sww/T_samp;

%% 1. Initialize waveforms
phi_t = Wiener(var_phi, Ntot, pi*(2*rand(1) - 1));
w_t = sqrt(var_w)*randn(1, Ntot);

%% 2. PLL filtering (delay effects neglected)
wn = 296.8e6;

[numpsi, denpsi] = bilinear([0 2*zeta*wn wn^2], [1 2*zeta*wn wn^2], 1/T_samp);
[num, den] = bilinear([2*zeta*wn wn^2 0], [1 2*zeta*wn wn^2], 1/T_samp);
psi_t = filter(numpsi, denpsi, phi_t) + filter(numpsi, denpsi, w_t);
freq_t = filter(num, den, phi_t) + filter(num, den, w_t);

figure;
plot(phi_t, 'LineWidth', 1, 'DisplayName', 'Phase Noise');
hold on;
plot(psi_t, 'LineWidth', 1, 'DisplayName', 'Control Phase');
legend();

figure;
plot(freq_t);

(std(freq_t)*T_samp)*100e6
