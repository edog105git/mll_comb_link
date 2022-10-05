function output = compute_eta_c(x)
%compute_eta_c(x)
%   Computes constellation penalty factor given constellation points x.
%   Penalty factor is given as eta_c = E[|x|^2]E[1/|x|^2]. Uniform
%   probability amongst constellation points assumed.
M = length(x);                  % constellation size
output = (1/M^2)*sum(abs(x).^2)*sum(abs(x).^-2);
end