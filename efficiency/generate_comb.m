function [E_r, E_out] = generate_comb(DR_COMB_GEN, P_in, P, Q)
%generate_comb Computes reflected and output spectrum of dual-ring EO comb.
j = sqrt(-1);
%% 1. Form matrices (vectors) A, b, C, d, e
% 1(a). A and b
Ap = zeros(2*P+1, 2*P+1);
b = zeros(2*P+1, 1);
c = zeros(2*P+1, 1);

for i=1:size(Ap, 1)
    for k=1:size(Ap, 2)
        if abs(i-k)<=Q
            phi_k = DR_COMB_GEN.opt + (k-P-1)*DR_COMB_GEN.mod;
            phi_k_t = DR_COMB_GEN.opt_t...
                + 2*pi*(k-P-1)*DR_COMB_GEN.f_m*DR_COMB_GEN.T_t...
                + (k-P-1)*DR_COMB_GEN.mod_t;
            
            Ap(i, k) = DR_COMB_GEN.rp ...
                * besselj(i-k, DR_COMB_GEN.beta) ...
                * exp(j*phi_k) * ...
                (1 - DR_COMB_GEN.rp_t*exp(j*phi_k_t)...
                /(1 - DR_COMB_GEN.k2)) * ...
                (1/(1 - DR_COMB_GEN.rp_t*exp(j*phi_k_t)));
        end
    end
    
    b(i) = j*(DR_COMB_GEN.alpha*DR_COMB_GEN.alpha_t)^(1/4) * ...
        sqrt((1-DR_COMB_GEN.gamma1)*DR_COMB_GEN.k1* ...
        (1-DR_COMB_GEN.gamma2)*DR_COMB_GEN.k2* ...
        (1-DR_COMB_GEN.gamma3)*DR_COMB_GEN.k3) * ...
        exp(j*((DR_COMB_GEN.opt+DR_COMB_GEN.opt_t)/2)) * ...
        (1/(1 - DR_COMB_GEN.rp_t*exp(j*DR_COMB_GEN.opt_t))) * ...
        besselj(i-P-1, DR_COMB_GEN.beta) * sqrt(P_in);
    
    phi_i = DR_COMB_GEN.opt + (i-P-1)*DR_COMB_GEN.mod;
    phi_i_t = DR_COMB_GEN.opt_t + ...
        2*pi*(i-P-1)*DR_COMB_GEN.f_m*DR_COMB_GEN.T_t + ...
        (i-P-1)*DR_COMB_GEN.mod_t;
    c(i) = -sqrt((DR_COMB_GEN.k1*DR_COMB_GEN.k2* ...
        (1-DR_COMB_GEN.gamma1))/(1-DR_COMB_GEN.k2)) * ...
        (DR_COMB_GEN.alpha_t/DR_COMB_GEN.alpha)^(1/4) * ...
        DR_COMB_GEN.rp * exp(j*(phi_i + phi_i_t)/2) * ...
        (1/(1 - DR_COMB_GEN.rp_t*exp(j*phi_i_t)));
end

A = Ap-eye(2*P+1);
C = diag(c);

% 1(b). d and e
d = (1/(j*sqrt((1-DR_COMB_GEN.gamma3)*DR_COMB_GEN.k3)))*b;
e = zeros(2*P+1, 1);
e(P+1) = (sqrt((1-DR_COMB_GEN.gamma1)*(1-DR_COMB_GEN.k1)) - ...
    sqrt((DR_COMB_GEN.k1^2*(1-DR_COMB_GEN.gamma1))/(1-DR_COMB_GEN.k1)) * ... 
    ((DR_COMB_GEN.rp_t*exp(j*DR_COMB_GEN.opt_t))/...
    (1 - DR_COMB_GEN.rp_t*exp(j*DR_COMB_GEN.opt_t)))) * ...
    sqrt(P_in);

%% 2. Compute reflected and output fields
E_out = A\b;
E_r = C*pinv(A)*d + e;
end

