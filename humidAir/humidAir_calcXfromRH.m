%function [xW] = humidAir_calcXfromRH(RH, T, P)
% x in kg/kg, relative humidity in %, temperature °C, absolute pressure Pa

% basis of calculations is Arden Buck equation
% valid from probably -40 to probably 50 °C
% NOTE 4:  The definitions f1 and f2 for ice agree with an extrapolation of NBS values down to - 120 deg C, within 0.5%
%
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
    
    
    RH = 80;
    T = -8;
    P = 99500;
    P = P/100;  % calculations require hekto pascal (equal mbar)

%% f1 will calculate the vapor pressure in mbar from dew/frost point temperature in °C
%   or the saturation vapor pressure in mbar from actual temperature in °C
%  s is introduced for calculations 
if T > 0
    EFw = 1 + 10^-4 *(7.2 + P * (0.0320 + 5.9*10^-6 * T^2));
    f1wT = EFw * aw * exp((bw - T/dw) * T/(T + cw));    %saturation pressure from temperature
    f1wDP = (RH/100) * f1wT;  % vaporPressure
    xW = ((18.015/28.963) * f1wDP /(P - f1wDP));
else
    EFi = 1 + 10^-4 *(2.2 + P * (0.0383 + 6.4*10^-6 * T^2));
    f1iT = EFi * ai * exp((bi - T/di) * T/(T + ci));    %saturation pressure from temperature
    f1iDP = (RH/100) * f1iT;  % vaporPressure
    xW = ((18.015/28.963) * f1iDP /(P - f1iDP));
end




