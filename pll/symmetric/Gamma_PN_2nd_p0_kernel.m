function output = Gamma_PN_2nd_p0_kernel(wbar, x, zeta, p_0)
%Gamma_PN_2nd_p0_kernel(wbar, x, zeta, p_0)
%   Computes argument inside integral of Gamma_PN(x = wn*tau_d) for a
%   second-order loop on the p_0-th channel for a comb-based structure
%   (NOTE: ALTERNATIVE STRUCTURE).
output = ((2*zeta)/pi)*(wbar.^2 + 4*p_0^2*zeta^2 + p_0^2*wbar.^-2 ...
    - 2*p_0*cos(x*wbar) - 4*p_0*zeta*wbar.*sin(x*wbar)).^-1;
end

