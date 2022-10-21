function df = dlambda2df(lambda, dlambda)
%dlambda2df(lambda, dlambda) : converts wavelength spacing to frequency
%spacing.
% INPUT
% lambda  : operating wavelength
% dlambda : wavelength spacing
% OUTPUT
% df      : frequency spacing
c = 3e8;
df = (c/lambda^2)*dlambda;
end