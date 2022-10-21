% Calculates dispersion-limited distance for a multi-wavelength QPSK link.
% We have 13 channels centered at 1310 nm and spaced 80 GHz apart.
% When L set to 100 km, total dispersion on outermost channels are roughly
% 25 ps/nm. Therefore, 100 km is dispersion-limited distance.
c = 3e8;                 % speed of light (m/s)
L = 99e3;                 % fiber length (m)
Deltaf = 80e9;           % channel spacing (Hz)
Nchannel = 13;           % number of channels
lambda = 1310e-9;        % center wavelength (m)
fcenter = c/lambda;      % center frequency (Hz)
flow = fcenter - floor(Nchannel/2)*Deltaf;
fhigh = fcenter + floor(Nchannel/2)*Deltaf;
lambdalow = c/fhigh;
lambdahigh = c/flow;

myFiber = fiber(L);
myFiber.summary(lambdalow)
myFiber.summary(lambdahigh)