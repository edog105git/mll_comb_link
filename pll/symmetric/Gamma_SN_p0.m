function output = Gamma_SN_p0(x, zeta, p_0)
%Gamma_SN_p0(x, zeta)
%   Computes additive noise-component of variance in PLL. Integrates kernel
%   functions w.r.t. x. USED FOR P_0-TH CHANNEL (NOTE: ALTERNATIVE
%   STRUCTURE).
output = ...
    2*integral(@(wbar)Gamma_SN_2nd_p0_kernel(wbar, x, zeta, p_0), 0, Inf);
end