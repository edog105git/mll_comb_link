clear; clc;
%% 0. Parameters
M = 4;                                    % constellation size
b = log2(M);                              % bits per symbol
T_s = 1/56e9;                             % symbol interval (s)
gamma_s_dB = 10.8;                        % symbol SNR (dB)
Deltamu = 1e3;                            % beat RF linewidth (Hz)
zeta = 1/sqrt(2);
p_0 = 12;                                 % outer reference channel
n_PE = 2;                                   % = 1 if one pol. used for 
                                            % phase estimate
                                            % = 2 if two pol. used for
                                            % phase estimate

var_p = 2*pi*Deltamu*T_s;                 
eta_c = compute_eta_c(qammod(0:M-1, M));  % constellation penalty factor
gamma_s = 10^(gamma_s_dB/10);

%% 1. Sweep Variables
wnTs = linspace(1e-5, 1e-2, 500);
var_phi = zeros(size(wnTs));

%% 2. Case (A): tau_d = 0
tau_d = 0;
for i=1:length(wnTs)
    wn = wnTs(i)/T_s;
    var_phi(i) = (var_p/(4*zeta*wn*T_s))*Gamma_PN_p0(wn*tau_d, zeta, p_0) ...
        + (((1+4*zeta^2)*wn*T_s)/(4*zeta))*(eta_c/(2*n_PE*gamma_s))*Gamma_SN_p0(wn*tau_d, zeta, p_0);
end

phase_error_std = sqrt(p_0^2*var_phi)*(180/pi); % phase error standard deviation (deg)

figure;
plot((wnTs/T_s/10e9), phase_error_std, '--', 'LineWidth', 1.5, 'DisplayName', '\it\tau_{d}\rm = 0');
%xlabel('$\omega_{n}T_{s}$', 'Interpreter', 'latex'); 
%ylabel('$p_{0}\sigma_{\varepsilon_{m}}$ (degrees)', 'Interpreter', 'latex');
grid();

%% 3. Case (B): tau_d = 20*T_b
%%{
wnTs = linspace(1e-5, 3.5e-3, 500);
tau_d = 400e-12;
for i=1:length(wnTs)
    wn = wnTs(i)/T_s;
    var_phi(i) = (var_p/(4*zeta*wn*T_s))*Gamma_PN_p0(wn*tau_d, zeta, p_0) ...
        + (((1+4*zeta^2)*wn*T_s)/(4*zeta))*(eta_c/(2*gamma_s))*Gamma_SN_p0(wn*tau_d, zeta, p_0);
end

phase_error_std = sqrt(p_0^2*var_phi)*(180/pi); % phase error standard deviation (deg)

hold on; 
plot((wnTs/T_s/10e9), phase_error_std, 'LineWidth', 1.5, 'DisplayName', strcat('\it\tau_{d}\rm = ', num2str(tau_d/1e-9), ' ns'));
set(gca, 'FontName', 'Times', 'FontSize', 20);
ylim([0, 6]); xlim([0, 0.05]);
%%}