function output = Gamma_SN_2nd_kernel(wbar, x, zeta)
%Gamma_SN_2nd_kernel(wbar, x, zeta)
%   Computes argument inside integral of Gamma_SN(x = wn*tau_d) for a
%   second-order loop.
output = ((2*zeta)/(pi*(1 + 4*zeta^2)))*(4*zeta + wbar.^-2)...
    .*(wbar.^2 - 2*cos(x*wbar) - 4*zeta*wbar.*sin(x*wbar) + 4*zeta^2 ...
    + wbar.^-2).^-1;
end