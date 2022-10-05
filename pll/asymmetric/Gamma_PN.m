function output = Gamma_PN(x, zeta)
%Gamma_PN(x, zeta)
%   Computes phase noise-component of variance in PLL. Integrates kernel
%   functions w.r.t. x.
output = 2*integral(@(wbar)Gamma_PN_2nd_kernel(wbar, x, zeta), 0, Inf);
end