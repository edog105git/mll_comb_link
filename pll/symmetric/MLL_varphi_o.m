clear; clc;
% ALTERNATIVE STRUCTURE, POSTULATING SAME SNR ON BOTH CHANNELS.
% (2022-06-06)
%% 0. Parameters
M = 4;                                    % constellation size
b = log2(M);                              % bits per symbol
T_s = 1/56e9;                             % symbol interval (s)
gamma_s_dB = 10.8;                        % symbol SNR (dB)
Deltamu = 2e6;                            % beat linewidth (Hz)
zeta = 1/sqrt(2);
n_PE = 2;

var_p = 2*pi*Deltamu*T_s;                 
eta_c = compute_eta_c(qammod(0:M-1, M));  % constellation penalty factor
gamma_s = 10^(gamma_s_dB/10);

%% 1. Sweep Variables
wnTs = linspace(1e-5, 1e-1, 500);
var_phi = zeros(size(wnTs));

%% 2. Case (A): tau_d = 0
tau_d = 0;
for i=1:length(wnTs)
    wn = wnTs(i)/T_s;
    var_phi(i) = (var_p/(4*zeta*wn*T_s))*Gamma_PN(wn*tau_d, zeta) ...
        + (((1+4*zeta^2)*wn*T_s)/(4*zeta))*(eta_c/(2*n_PE*gamma_s))*Gamma_SN(wn*tau_d, zeta) ...
        + (((1+4*zeta^2)*wn*T_s)/(4*zeta))*(eta_c/(2*n_PE*gamma_s))*Gamma_SN(wn*tau_d, zeta);
end

phase_error_std = sqrt(var_phi)*(180/pi); % phase error standard deviation (deg)

figure;
plot(wnTs/T_s/10e9, phase_error_std, '--', 'LineWidth', 1.5, 'DisplayName', '\it\tau_{d}\rm = 0');
grid();

%% 3. Case (B): tau_d = non-zero
wnTs = linspace(1e-6, 3e-2, 500);
tau_d = 400e-12;
for i=1:length(wnTs)
    wn = wnTs(i)/T_s;
    var_phi(i) = (var_p/(4*zeta*wn*T_s))*Gamma_PN(wn*tau_d, zeta) ...
        + (((1+4*zeta^2)*wn*T_s)/(4*zeta))*(eta_c/(2*n_PE*gamma_s))*Gamma_SN(wn*tau_d, zeta) ...
        + (((1+4*zeta^2)*wn*T_s)/(4*zeta))*(eta_c/(2*n_PE*gamma_s))*Gamma_SN(wn*tau_d, zeta);
end

phase_error_std = sqrt(var_phi)*(180/pi); % phase error standard deviation (deg)

hold on; 
plot(wnTs/T_s/10e9, phase_error_std, 'LineWidth', 1.5, 'DisplayName', strcat('\it\tau_{d}\rm = ', num2str(tau_d/1e-12), ' ps'));
set(gca, 'FontName', 'Times', 'FontSize', 20);
ylim([0, 8]); xlim([0, 0.5]);