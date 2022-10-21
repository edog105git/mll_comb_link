%% 0. Define parameters and constants.
% 0(a). Constants
j = sqrt(-1);
c = 3e8;                                          % speed of light (m/s)
hbar = 1.054e-34;                                 % reduced Planck's constant
q = 1.602e-19;                                    % electron charge
% 0(b). Component bandwidths
Delta_f = 56e9;
Delta_mu_s = 80e9;
Delta_mu_LO = 80e9;
% 0(d). Receiver
N0 = (30e-12)^2;
R = 1;
% 0(e). Amplifiers
G1_dB = 20; G1 = 10^(G1_dB/10);
GLO_dB = 15; GLO = 10^(GLO_dB/10);
Fn1_dB = 7; Fn1 = 10^(Fn1_dB/10);
FnLO_dB = 7; FnLO = 10^(FnLO_dB/10);
% 0(f). System losses
eta1_dB = -5; eta1 = 10^(eta1_dB/10);
eta2_dB = -10; eta2 = 10^(eta2_dB/10);
eta3_dB = -6.3; eta3 = 10^(eta3_dB/10);
eta4_dB = -10; eta4 = 10^(eta4_dB/10);
eta1LO_dB = -3; eta1LO = 10^(eta1LO_dB/10);
eta2LO_dB = -1.5; eta2LO = 10^(eta2LO_dB/10);
% 0(g). Signal parameters
lambda = 1310e-9;
omega_0 = (2*pi*c)/lambda;

Nchannel = 13;

P_Tx_lowest_dB = -10;
P_LO_lowest_dB = 0;

P_Tx_lowest = 10^(P_Tx_lowest_dB/10)*1e-3;
P_LO_lowest = 10^(P_LO_lowest_dB/10)*1e-3;
%% 2. Compute signal + noise powers.
% 2(a). Signal power PER POLARIZATION
% * NOTE: Factor of 1/2 to reflect power per polarization
P_s = (1/2)*eta1*G1*eta2*eta3*P_Tx_lowest;
% 2(b). LO power PER POLARIZATION
% * NOTE: Factor of 1/2 to reflect power per polarization
P_LO = (1/2)*eta1LO*GLO*P_LO_lowest;
% 2(b). ASE PSD's
S_sps = eta2*eta3*(G1 - 1)*nspfromFndB(Fn1_dB)*hbar*omega_0;
S_spLO = (GLO - 1)*nspfromFndB(FnLO_dB)*hbar*omega_0;
% 2(c). Thermal noise
var_thermal = N0*Delta_f
% 2(d). Shot noise
var_shot = q*R*(eta4*P_s + eta2LO*P_LO + eta4*S_sps*Delta_mu_s + eta2LO*S_spLO*Delta_mu_LO)*Delta_f
% 2(e). LO-sig. spont. noise
var_LOsigspont = R^2*eta2LO*P_LO*eta4*S_sps*min(Delta_f, Delta_mu_s/2)
% 2(f). sig.-LO spont. noise
var_sigLOspont = R^2*eta4*P_s*eta2LO*S_spLO*min(Delta_f, Delta_mu_LO/2)
%% 3. Check
% 3(a). Total power exiting G1
check_1 = eta1*G1*P_Tx_lowest*Nchannel; check_1_dBm = 10*log10(check_1/1e-3)
check_2 = eta1LO*GLO*P_LO_lowest*Nchannel; check_2_dBm = 10*log10(check_2/1e-3)
%% 4. Compute receiver sensitivity and/or SNR per symbol.
SNR = (R^2*eta4*P_s*eta2LO*P_LO)/(var_thermal + var_shot + var_LOsigspont + var_sigLOspont);
SNR_dB = 10*log10(SNR)