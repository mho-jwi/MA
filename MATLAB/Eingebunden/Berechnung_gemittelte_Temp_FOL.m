function [T_FOL] = Berechnung_gemittelte_Temp_FOL (T_FOL_L, T_FOL_R, T_FOL_U, T_FOL_O, T_FOL_Mitte);
%Abmaße der Abströmfläche Enthalpieübertragers  in mm
% x = 450;
% y = 196;
% 
% %Fläche der Abströmfläche des Enthalpieübertragers in mm²
% A = x*y;
% 
% %Referenz-Temperaturdifferenz in °C 
% delta_T_ref = T_AUL - T_ABL;
% delta_T_FOL = [-17498.24+3430.98*delta_T_ref]/A;
% T_FOL = T_FOL_Mitte + delta_T_FOL;
% end
%% 

T_OL = ((T_FOL_L-T_FOL_Mitte)*125/250+(T_FOL_O-T_FOL_Mitte)*50/100)+T_FOL_Mitte;
T_OR = ((T_FOL_R-T_FOL_Mitte)*125/250+(T_FOL_O-T_FOL_Mitte)*50/100)+T_FOL_Mitte;
T_UL = ((T_FOL_L-T_FOL_Mitte)*125/250+(T_FOL_U-T_FOL_Mitte)*50/100)+T_FOL_Mitte;
T_UR = ((T_FOL_R-T_FOL_Mitte)*125/250+(T_FOL_U-T_FOL_Mitte)*50/100)+T_FOL_Mitte;

T_FOL = (T_OL+T_OR+T_UL+T_UR)/4;
end

