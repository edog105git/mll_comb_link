  function output = Gamma_PN_2nd_kernel(wbar, x, zeta)
%Gamma_PN_2nd_kernel(wbar, x, zeta)
%   Computes argument inside integral of Gamma_PN(x = wn*tau_d) for a
%   second-order loop (NOTE: ALTERNATIVE STRUCTURE).
output = ((2*zeta)/pi)*(wbar.^2 + 4*zeta^2 + wbar.^-2 ...
    - 2*cos(x*wbar) - 4*zeta*wbar.*sin(x*wbar)).^-1;
end