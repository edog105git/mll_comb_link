function output = Wiener(var, N, initial)
%Wiener(var) 
%   Creates instance of Wiener process with N points and starting with
%   initial.
delta = [0 sqrt(var)*randn(1, N-1)];
output = initial + cumsum(delta, 2);
end