% Compute overall efficiency for EO comb and MLL comb

%% EO COMB
clear; clc;
Po0 = 0.14;                        % seed laser output optical power (W)
eta_Eo1 = 0.1;                     % WPE of seed laser (W/W)
P_Em = 2;                          % electrical power of microwave modulation (W)

P_o2 = 36.64e-3;                   % total SOA optical output (W)
G = 10^(20/10);                    % SOA gain (W/W)
eta_Eo2 = 0.15;                    % WPE of SOA (W/W)

P_E0 = Po0/eta_Eo1;                % electrical power going to seed laser generation (W)
P_E2 = (P_o2/eta_Eo2)*(1 - (1/G)); % electrical power going to SOA (W)

eta_overall = P_o2/(P_E0 + P_Em + P_E2);
eta_overall*100

%% MLL COMB
clear;
P_o2 = 36.64e-3;
G = 10^(20/10);
eta_oo = 10^(-5.5/10)*0.7*0.5;
eta_Eo1 = 0.1;
P_Em = 200e-3;
eta_Eo2 = 0.15;

P_E1 = P_o2/(G*eta_oo*eta_Eo1);
P_E2 = (P_o2/eta_Eo2)*(1 - (1/G));
P_o1 = (P_o2/(eta_oo*G))*1e3

eta_overall  = P_o2/(P_E1 + P_Em + P_E2);
eta_overall*100