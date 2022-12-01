%% Compute Dual-Resonator EO comb effiency.
% - Designing for comb with 12 lines on each side of central line.
TX_COMB.ring_factor = 13.5;
TX_COMB.k1 = 0.03; TX_COMB.k2 = 0.03; TX_COMB.k3 = 0.03;
TX_COMB.gamma1 = 0; TX_COMB.gamma2 = 0; TX_COMB.gamma3 = 0;

TX_COMB.T = 1/40e9; TX_COMB.alpha = 0.95; 
TX_COMB.rp = sqrt(TX_COMB.alpha*(1-TX_COMB.gamma3)*...
    (1-TX_COMB.k3)*(1-TX_COMB.gamma2)*(1-TX_COMB.k2));
TX_COMB.beta = .5*pi;
TX_COMB.f_m = 40e9;
TX_COMB.w_m = 2*pi*TX_COMB.f_m;

TX_COMB.T_t = TX_COMB.T/TX_COMB.ring_factor; TX_COMB.alpha_t = TX_COMB.alpha^...
    (TX_COMB.T_t/TX_COMB.T);
TX_COMB.rp_t = sqrt(TX_COMB.alpha_t*(1-TX_COMB.gamma1)*...
    (1-TX_COMB.k1)*(1-TX_COMB.gamma2)*(1-TX_COMB.k2));

TX_COMB.opt = 0;
TX_COMB.mod = 0;
TX_COMB.opt_t = TX_COMB.opt*(TX_COMB.T_t/TX_COMB.T);
TX_COMB.mod_t = TX_COMB.mod*(TX_COMB.f_m*TX_COMB.T_t);
P = 100;
Q = 150;

P_in_total = 35.10e-3;
% 1. Seed-to-comb conversion
[E_r, E_out] = generate_comb(TX_COMB, P_in_total, P, Q);
P_r = abs(E_r).^2;
P_out = abs(E_out).^2;
%{
figure;
plot(-P:P, 10*log10(P_out/1e-3), 'LineWidth', 1.5);
grid(); xlabel('Comb Line Number \itp'); ylabel('Power (dBm)');
title('Transmitter Comb');
xlim([-20, 20]);
%}
comb_left = P_out(-12+P+1:P);
comb_center = P_r(P+1);
comb_right = P_out(P:12+P+1);

P_comb_output = sum(comb_left) + comb_center + sum(comb_right);
% 2. De-interleave + take central line from ref-port.
comb_left_DI = P_out((-12+P+1):2:P);
comb_center_DI = P_r(P+1);
comb_right_DI = P_out((2+P+1):2:(12+P+1));

P_DI_output = sum(comb_left_DI) + comb_center_DI + sum(comb_right_DI);

P_lowest = min(min(min(comb_left_DI), min(comb_right_DI)), comb_center_DI)
% 3. Compute efficiencies
eta_WPE = 0.1;                                                             % wall-plug efficiency (value taken from literature)
eta_cc = P_comb_output/P_in_total;                                         % comb conversion efficiency (power in center 25 channels / total seed laser power)
eta_DI = P_DI_output/P_comb_output;                                        % DI efficiency
eta_FF = (P_lowest*13)/P_DI_output;
eta_cc*eta_DI*eta_FF*100;
P_lowest;

10*log10(P_lowest/1e-3)