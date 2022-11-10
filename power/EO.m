eta_laser = 0.15;
eta_soa = 0.19;
P_seed_Tx = 0.014;
P_seed_LO = 0.14;
G_Tx = 10^(20/10);
G_LO = 10^(10/10);
P_soa_Tx = 36.63e-3;
P_soa_LO = 36.63e-3;
P_Rx_electronics = 2.7;

%% Tx
P_E1_Tx = P_seed_Tx/eta_laser;
P_m_Tx = 2;
P_E2_Tx = (P_soa_Tx/eta_soa)*(1 - (1/G_Tx));

P_Tx = P_E1_Tx + P_m_Tx + P_E2_Tx;

%% LO
P_E1_LO = P_seed_LO/eta_laser;
P_m_LO = 2;
P_E2_LO = (P_soa_LO/eta_soa)*(1 - (1/G_LO));

P_LO = P_E1_LO + P_m_LO + P_E2_LO;

P_total = (P_Tx + P_LO + P_Rx_electronics)*2