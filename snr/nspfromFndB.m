function nsp = nspfromFndB(FndB)
%nspfromFndB calculates nsp from Fn_dB (noise figure)
Fn = 10.^(FndB/10);
nsp = Fn/2;
end

