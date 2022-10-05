function output = Gamma_SN_2nd_p0_kernel(wbar, x, zeta, p_0)
%Gamma_SN_2nd_p0_kernel(wbar, x, zeta, p_0)
%   Computes argument inside integral of Gamma_SN(x = wn*tau_d) for a
%   second-order loop on the p_0-th channel for a comb-based structure
%   (NOTE: ALTERNATIVE STRUCTURE).
output = (zeta/(2*pi*(1 + 4*zeta^2)))*(4*zeta + wbar.^-2)...
    .*(wbar.^2 - 2*p_0*cos(x*wbar) - 4*zeta*p_0*wbar.*sin(x*wbar)...
    + 4*p_0^2*zeta^2 + p_0^2*wbar.^-2).^-1;
end

