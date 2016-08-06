function [deltaXw] = errorPropagationRHtoX(RH, deltaRH, T, deltaT, P, deltaP)
% input variables
% relative humidity, error,
% temperature, error,
% absolute pressure, error,
% the error values have to be given as full range,
% e.g. +/-2 % RH --> error = 4 % RH !!!

% funtion estimates linear error propagation from relative humidity measurement to
% calculated water content.

% basis of calculations is Arden Buck equation
% valid from probably -40 to probably 50 °C
% NOTE 4:  The definitions f1 and f2 for ice agree with an extrapolation of NBS values down to - 120 deg C, within 0.5%
%
% http://www.hygrometers.com/wp-content/uploads/CR-1A-users-manual-2009-12.pdf

%% measurement data
% RH = 30;         % %r.h.        relative humidity
% P = 1013.25;    % mbar      ambient pressure (hPa respectively)
% T = 25;         % in °C     ambient temperature

% measurement uncertainty
% deltaRH 
% deltaP 
% deltaT


%% enhancement factors Water / Ice
    aw = 6.1121;
    bw = 18.678;
    cw = 257.14;
    dw = 234.5;

    ai = 6.1115;
    bi = 23.036;
    ci = 279.82;
    di = 333.7;

%% formula f1 will calculate the vapor pressure in mbar from dew/frost point temperature in °C
%   or the saturation vapor pressure in mbar from actual temperature in °C
    EFw = 1 + 10^-4 *(7.2 + P * (0.0320 + 5.9*10^-6 * T^2));
%     EFi = 1 + 10^-4 *(2.2 + P * (0.0383 + 6.4*10^-6 * T^2));

    f1w = EFw * aw * exp((bw - T/dw) * T/(T + cw));     % mbar / hPa
%     f1i = EFi * ai * exp((bi - T/di) * T/(T + ci));     % mbar / hPa

%% formula f2 still to be implemented
% sw = ln( e/EF ) - ln(aw);
% si = ln( e/EF ) - ln(ai);


%% error calculations
% 
%% relative humidity sensor - calculcation of water mass above 0°C
% note: in case RH is already calculated through temperature (honeywell
% sensors for example), this equation is not absolutely correct!

% input data with possible error and output variable
syms symP symRH symT

% combination of following equations altogether 
% EFw = (1 + 10^-4 *(7.2 + P * (0.0320 + 5.9*10^-6 * T^2)));
% f1w = pVaporWsat = (EFw * aw * exp((bw - T/dw) * T/(T + cw)));    % in mbar
% pVaporW = (pVaporWsat * RH / 100);                                % in mbar
% xW = ((18.015/28.963) * pVaporW /(P - pVaporW)*1000);             % g/kg


xW = ((18.015 / 28.963) * (((1 + 10^-4 *(7.2 + symP * (0.0320 + 5.9*10^-6 * symT^2))) * aw * exp((bw - symT/dw) * symT/(symT + cw))) * symRH / 100) /(symP - (((1 + 10^-4 *(7.2 + symP * (0.0320 + 5.9*10^-6 * symT^2))) * aw * exp((bw - symT/dw) * symT/(symT + cw))) * symRH / 100))*1000);

symdxWdP = diff(xW,symP);
symdxWdRH = diff(xW,symRH);
symdxWdT = diff(xW,symT);

dxWdP = subs(symdxWdP, [symP, symRH, symT], [P, RH, T]);
dxWdRH = subs(symdxWdRH, [symP, symRH, symT], [P, RH, T]);
dxWdT = subs(symdxWdT, [symP, symRH, symT], [P, RH, T]);

deltaXw = abs(dxWdP * deltaP) + abs(dxWdRH * deltaRH)  + abs(dxWdT * deltaT);
deltaXw = eval(deltaXw);


