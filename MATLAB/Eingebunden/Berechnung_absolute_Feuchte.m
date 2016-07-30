function [x_AUL, x_ABL, x_ZUL, x_FOL] = Berechnung_absolute_Feuchte(Feuchtesensortemperaturen, Feuchtewerte, P_amb);
% x in kg/kg, relative feuchte in %, Temperaturen in °C, absolute Druck in Pa

% Grundlage der Berechnung ist die Arden Buck Gleichung
% Gültig von ca. -40 bis ca. 50 °C
% NOTE 4:  The definitions f1 and f2 for ice agree with an extrapolation of NBS values down to - 120 deg C, within 0.5%
%
% http://www.hygrometers.com/wp-content/uploads/CR-1A-users-manual-2009-12.pdf

%% Stoffwerte für Wasser/ Eis
    aw = 6.1121;
    bw = 18.678;
    cw = 257.14;
    dw = 234.5;

    ai = 6.1115;
    bi = 23.036;
    ci = 279.82;
    di = 333.7;
    
    P_amb = P_amb/100;  % Die Berechnung in hekto pascal (equal mbar)

%% f1 will calculate the vapor pressure in mbar from dew/frost point temperature in °C
%   or the saturation vapor pressure in mbar from actual temperature in °C
%  s is introduced for calculations 

for scount = 1:size(Feuchtesensortemperaturen,2),
    T = Feuchtesensortemperaturen(:,scount);
    RH = Feuchtewerte (:,scount);
    einvec = ones(size(T,1),1);
if T > 0
    EFw = 1 + 10^-4 *(7.2 + P_amb * (0.0320 + 5.9*10^-6 * T.^2));
    f1wT = EFw * aw .* exp((bw*einvec - T/dw) .* T./(T + cw*einvec));    %saturation pressure from temperature
    f1wDP = (RH/100) .* f1wT;  % vaporPressure
    xW = ((18.015/28.963) * f1wDP ./(P_amb*einvec - f1wDP));
else
    EFi = 1 + 10^-4 *(2.2 + P_amb * (0.0383 + 6.4*10^-6 * T.^2));
    f1iT = EFi * ai .* exp((bi - T/di) .* T./(T + ci));    %saturation pressure from temperature
    f1iDP = (RH/100) .* f1iT;  % vaporPressure
    xW = ((18.015/28.963) * f1iDP ./(P_amb - f1iDP));
end


if scount == 1
 %   T_AUL = T;
 %  PHI_AUL = RH;
 x_AUL = xW;
elseif scount == 2
 %   T_ABL = T;
 %   PHI_ABL = RH;
 x_ABL = xW;
elseif scount == 3
 %   T_ZUL_PHI = T;
 %   PHI_ZUL = RH;
 x_ZUL = xW;
elseif scount == 4
 %   T_FOL_PHI = T;
 %   PHI_FOL = RH;
 x_FOL = xW;
end

end
clear T RH EFw f1wT f1wDP EFi f1iDP aw bw cw dw ai bi ci di scount einvec %Zwischenwerte löschen
end