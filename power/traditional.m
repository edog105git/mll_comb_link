eta_WPE = 0.15;
eta_demux = 10^(-1.5/10);
P_soa_Tx = 36.63e-3; 
P_soa_LO = 36.63e-3;
N_ch = 13;

P_laser_Tx = (P_soa_Tx*eta_demux)/N_ch;
P_Tx = (P_laser_Tx/eta_WPE)*N_ch;

P_laser_LO = (P_soa_LO*eta_demux)/N_ch;
P_LO = (P_laser_LO/eta_WPE)*N_ch;

P_Rx_electronics = 3.3;

P_cooling = P_Tx + P_LO + P_Rx_electronics;

P_total = P_Tx + P_LO + P_Rx_electronics + P_cooling