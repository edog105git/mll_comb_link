function output = Gamma_SN(x, zeta)
%Gamma_SN(x, zeta)
%   Computes additive noise-component of variance in PLL. Integrates kernel
%   functions w.r.t. x (NOTE: ALTERNATIVE STRUCTURE).
output = 2*integral(@(wbar)Gamma_SN_2nd_kernel(wbar, x, zeta), 0, Inf);
end