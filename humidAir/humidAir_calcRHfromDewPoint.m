function [RH] = humidAir_calcRHfromDewPoint(DP, T, P)
%%   dew point in °C, temperature in °C, pressure in mbar/hPa
% 
% Arden Buck equation,  valid from -45 to 60 °C over flat water surface
% valid from probably -40 to probably 50 °C
% http://www.hygrometers.com/wp-content/uploads/CR-1A-users-manual-2009-12.pdf

%% enhancement factors Water / Ice
aw = 6.1121;
bw = 18.678;
cw = 257.14;
dw = 234.5;


ai = 6.1115;
bi = 23.036;
ci = 279.82;
di = 333.7;

%% f1 will calculate the vapor pressure in mbar from dew/frost point temperature in °C
%   or the saturation vapor pressure in mbar from actual temperature in °C
%  s is introduced for calculations 
if T > 0
    EFw = 1 + 10^-4 *(7.2 + P * (0.0320 + 5.9*10^-6 * T^2));
    f1wDP = EFw * aw * exp((bw - DP/dw) * DP/(DP + cw));
    f1wT = EFw * aw * exp((bw - T/dw) * T/(T + cw));
    RH = 100 * f1wDP / f1wT;
else
    EFi = 1 + 10^-4 *(2.2 + P * (0.0383 + 6.4*10^-6 * T^2));
    f1iDP = EFi * ai * exp((bi - DP/di) * DP/(DP + ci));
    f1iT = EFi * ai * exp((bi - T/di) * T/(T + ci));
    RH = 100 * f1iDP / f1iT;
end








%%