function [T_m_f, T_m_e, x_m_f, x_m_e] = Thermodynamische_Mittelwerte (T_ZUL, T_AUL, T_FOL, T_ABL, x_ZUL, x_AUL, x_ABL, x_FOL);


%gesamte gemittelte Feuchtewertdifferenz über den Übertrager, jeweils
%differenz vorne und hinten bilden und dann logarithmisch mitteln,
%für Gegenstromübertrager
%Quelle: Progress on heat and moisture recovery with membranes: From
%fundamentals to engineering applications, Li-Zhi Zhang
%delta_x_lm = ((x_AUL-x_FOL) - (x_ZUL - x_ABL))./log((x_ZUL-x_FOL)./(x_ZUL-x_ABL));
%delta_T_lm = ((T_AUL-T_FOL) - (T_ZUL - T_ABL))./log((T_ZUL-T_FOL)./(T_ZUL-T_ABL));



%logarithmisch gemittelte Feuchtewerte für die Frischluft und die
%Exhaustluft, analog zur Temperatur
%selbst definiert
x_m_f = (x_ZUL - x_AUL)./log(x_ZUL./x_AUL);
x_m_e = (x_ABL - x_FOL)./log(x_ABL./x_FOL);

%delta_x_m = x_m_f - x_m_e;


%thermodynische Mitteltemperatur, allgemein bekannt, als Quelle ggf. Wärme
%und Stoffübertragung
T_m_f = (T_ZUL - T_AUL)./log((T_ZUL+273.15)./(T_AUL+273.15))-273.15;
T_m_e = (T_ABL - T_FOL)./log((T_ABL+273.15)./(T_FOL+273.15))-273.15;

%delta_T_m = T_m_f - T_m_e;

end





