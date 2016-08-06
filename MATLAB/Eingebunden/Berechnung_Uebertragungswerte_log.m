function [k_sen_Zhang, k_lat_Zhang, NTU_sen_Zhang, NTU_lat_Zhang, eff_lat, eff_sen] = Berechnung_Uebertragungswerte(T_ABL, T_AUL, T_FOL, T_ZUL, x_AUL, x_ZUL, x_ABL, x_FOL, P_amb);

%function [NTU_lat,NTU_sen] = Waerme_Stofftransportmodell_Enthalpietauscher()
% Modell Feuchtetransport Enthalpietauscher
%excel_read;

% Stoffdaten Luftstrom
% Waermekapazitaet [kJ/kg/K]
cp_f = 1.005;
cp_e = 1.005;


%spezifische Gaskonstante von Luft in J/(kg*K), Quelle:Thermodynamic für
%Igenieure und http://physics.nist.gov/cgi-bin/cuu/Value?r
R = 287.058;
% Anlagendaten
% Membranfläche [m²]
A = 19.055;
V = 400;
m = 185;

%Dichte Luft in [kg/m³]
rho_l = 1.272;
% % Betriebsbedingungen
% % Temperaturen [°C]
% T_ZUL = T_ZUL_PHI;
% T_FOL = T_FOL_PHI;


einvec = ones(size(T_AUL,1),1);

% % Massenstroeme Luft [kg/s] 
m_f = V * P_amb./(R*(T_AUL+273.15)).*(1*einvec+x_AUL)/3600
m_e = V * P_amb./(R*(T_AUL+273.15)).*(1*einvec+x_ABL)/3600;


% % Kapazitaetsstromkoeffizient
R_f = m_f*cp_f./(m_e*cp_e);
% R_e = m_e*cp_e./(m_f*cp_f);

%Wärmekpazitätstrom [KJ/K/s]
W_f = m_f*cp_f;
W_e = m_e*cp_e;

%%  effectiveness

% sensibel

eff_sen = (m_f * cp_f .* (T_AUL-T_ZUL))./ (min(W_f,W_e).*(T_AUL-T_ABL));

% latent
eff_lat = (m_f .*  (x_AUL-x_ZUL))./ (min(m_f,m_e).*(x_AUL-x_ABL));

%% for counterflow


% %%übereinstimmend in VDI und Veröffentlichungen, Z.B. Zhang "Progress on heat and moisture recovery with
% %membranes: From fundamentals to engineering applications" und "Effectiveness Correlations for Heat and Moisture Transfer Processes in an Enthalpy Exchanger With Membrane Cores"
% 
% NTU_sen = 1/(1-R_f_sen)*ln((1-R_f_sen*eff_sen)/(1-eff_sen));
% NTU_lat = 1/(1-R_f_lat)*ln((1-R_f_sen*eff_lat)/(1-eff_lat));
% 


% 
%% concurrent flow/ Gleichstrom
% %NTU nach Zusammenhang aus "Progress on heat and moisture recovery with
% %membranes: From fundamentals to engineering applications", Zhang
% NTU_lat = -ln(1-eff_lat*(1+R_f_lat))/(1+R_f_lat);
% 
% 
%% for crossflow

% 
% %aus "Effectiveness Correlations for Heat and Moisture Transfer Processes
% %in an Enthalpy Exchanger With Membrane Cores", Zhang, in Bezug auf
% %"Comapct heat exchangers", Kays and London: parameterfun_sen und
% %parameterfun_lat
% 
% 
% 
 a =  size (T_AUL,1);
 x0 = ones (a,1);
  
  f = @(x)parameterfun_sen(x,R_f,eff_sen);

 [x,fval,exitflag,output,jacobian] = fsolve(f,x0);
 
 NTU_sen_Zhang = x;
 
 
% %k in [KW/K/m²]
 k_sen_Zhang = NTU_sen_Zhang .* W_f ./ A;
% 
% 
% 
 y0 = ones(a,1);
 
     f_lat = @(y)parameterfun_lat(y,R_f,eff_lat);
     
     [y,fval_lat,exitflag_lat,output_lat,jacobian_lat] = fsolve(f_lat,y0);
 
 NTU_lat_Zhang = y;
 %k in [kg/s/m²]
 k_lat_Zhang = NTU_lat_Zhang.*m_f./A;
% 
% 
% 
% 
% 
% 


%% aus VDI: parameterfun_sen_cross


%approximierter Zusammenhang aus VDI für Crossflow, analog übertragen für
%Feuchte


% a =  size (T_AUL,1);
%  x0 = ones (a,1);
% 
% einvec = ones(size(R_f,1),1);
% faccounta = 0;
% faccountb = 0;
% for j = 1:m;
%     faccounta = faccounta + 1/factorial(j);
%     faccountb = faccountb + 1/factorial(j)*R_f*x.^factorial(j);
%     
%  
%  f = @(x)parameterfun_sen_cross(x,R_f,eff_sen,faccoounta,faccountb);
% 
% [x,fval,exitflag,output,jacobian] = fsolve(f,x0);
% 
% end
% 
% NTU_sen_vdi = x;
% 
% %k in [KW/K/m²]
% k_sen_vdi = NTU_sen_vdi .* W_f ./ A;
% 
% 
% 
% einvec = ones(size(R_f,1),1);
% faccounta = 0;
% faccountb = 0;
% for j = 1:m;
%     faccounta = faccounta + 1/factorial(j);
%     faccountb = faccountb + 1/factorial(j)*R_f*x^factorial(j);
% 
%  y0 = ones(a,1);
%  
%       f_lat = @(x)parameterfun_sen_cross(y,R_f,eff_lat,faccoounta,faccountb);
%      
%      [y,fval_lat,exitflag_lat,output_lat,jacobian_lat] = fsolve(f_lat,y0);
% end
%  NTU_lat_vdi = y
%  %k in [kg/s/m²]
%  k_lat_vdi = NTU_lat_vdi*m_f./A

 
%% direkte Berechnung aus Feuchte, Temperaturdifferenz
% 
% 
% % %NTU nach Zusammenhang aus "Progress on heat and moisture recovery with
% % %membranes: From fundamentals to engineering applications", Zhang
% % %direkte Berechnung aus Feuchte, Temperaturdifferenz
% % % k_lat in [m/s]
%  k_lat_lm = (V * (x_AUL-x_ZUL)/(A*delta_x_lm));
%  
% % %analog k_sen in [m/s]
%  k_sen_lm = (V * (T_AUL-T_ZUL_Mitte)/(A*delta_T_lm));
% % 
% % 
% % %optional Energiebasiert, k_lat in [kW/m²]
%  k_lat_lme = (x_AUL-x_ZUL)*m_f*h_w/(A*delta_x_lm);
%  k_sen_lme = (T_AUL-T_ZUL_Mitte)*cp_f*m_f/(A*delta_T_lm);

end