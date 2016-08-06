function [T_ZUL] = Berechnung_gemittelte_Temp_ZUL (T_ZUL_L, T_ZUL_R, T_ZUL_Mitte, T_ZUL_O, T_ZUL_U);

%Abmaße der Abströmfläche Enthalpieübertragers  in mm
% x = 450;
% y = 196;
% 
% %Fläche der Abströmfläche des Enthalpieübertragers in mm²
% A = x*y;
% 
% %Referenz-Temperaturdifferenz in °C 
% delta_T_ref = T_AUL - T_ABL;
% delta_T_ZUL = [94366.77-0.0888*delta_T_ref]/A;
% 
% T_ZUL = delta_T_ZUL + T_ZUL_Mitte;

%% 
T_OL = ((T_ZUL_L - T_ZUL_Mitte) * 0.5 + (T_ZUL_O - T_ZUL_Mitte) * 0.5) + T_ZUL_Mitte;
T_OR = ((T_ZUL_R-T_ZUL_Mitte)*0.5+(T_ZUL_O-T_ZUL_Mitte)*0.5)+T_ZUL_Mitte;
T_UL = ((T_ZUL_L-T_ZUL_Mitte)*0.5+(T_ZUL_U-T_ZUL_Mitte)*0.5)+T_ZUL_Mitte;
T_UR = ((T_ZUL_R-T_ZUL_Mitte)*0.5+(T_ZUL_U-T_ZUL_Mitte)*0.5)+T_ZUL_Mitte;

T_ZUL = (T_OL+T_OR+T_UL+T_UR)/4;

% 
% 
% Ort = [0,250,250,250,500;100,0,100,200,100];
% 
% 
% 
% for scount=1:5
%     if Ort(1,scount) == 0
%         T = T_ZUL_L;
%     elseif Ort (1,scount) == 250
%         if Ort (2,scount) == 0
%             T = T_ZUL_U;
%         elseif Ort(2,scount) == 100
%             T = T_ZUL_Mitte;
%         elseif Ort (2,scount) == 200
%             T = T_ZUL_O;
%         end
%     elseif Ort (1,scount) == 500
%         T = T_ZUL_R;
%     end
%   ZWI (scount,1) = T;
% end
% 
% x = [0;250;250;250;500];
% y = [100;0;100;200;100];
% 
% sf = fit([x,y],ZWI,'poly23');
% plot (sf,[x,y],ZWI);

end