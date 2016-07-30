function [NTU_sen, NTU_lat, k_sen, k_lat, eff_lat,  eff_sen] = Berechnung_Uebertragungswerte(PHI_ABL, PHI_AUL, PHI_FOL, PHI_ZUL, T_ABL, T_AUL, T_FOL_PHI, T_ZUL_PHI, x_AUL, P_amb, R,m);

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
A = 100;
V = 400;

% % Betriebsbedingungen
% % Temperaturen [°C]
% T_AUL = [10;11];
 T_ZUL = T_ZUL_PHI;
% T_ABL = [23;24];
 T_FOL = T_FOL_PHI;

% % Feuchtebeladungen [kg/kg]
% PHI_AUL = [1;1.1];
% PHI_ZUL = [4;4.1];
% PHI_ABL = [5;5.1];
% PHI_ZULL = [2;2.1];
% 
einvec = ones(size(T_AUL,1),1);

% % Massenstroeme Luft [kg/s] 
m_strom_f = V * P_amb./(R*T_AUL).*(1*einvec+x_AUL)/3600;
m_strom_e = m_strom_f;


% % Kapazitaetsstromkoeffizient
R_f = m_strom_f*cp_f./(m_strom_e*cp_e);
% R_e = m_strom_e*cp_e./(m_strom_f*cp_f);

%Wärmekpazitätstrom [KJ/K/s]
W_f = m_strom_f*cp_f;
W_e = m_strom_e*cp_e;


% effectiveness
% sensibel

eff_sen = (m_strom_f * cp_f .* (T_AUL-T_ZUL))./ (min(W_f,W_e).*(T_AUL-T_ABL));

% latent
eff_lat = (m_strom_f .*  (PHI_AUL-PHI_ZUL))./ (min(m_strom_f,m_strom_e).*(PHI_AUL-PHI_ABL));


% %Zusammenhaenge zwischen NTU und effectiveness
% NTU_sen = 1;
% NTU_lat = 1;
% 
% eff_sen_step = 1 - exp((exp(-R_f*NTU_sen^0.78)-1)/(R_f*NTU_sen^(-0.22)));
% eff_lat_step = 1 - exp((exp(-R_f*NTU_lat^0.78)-1)/(R_f*NTU_lat^(-0.22)));
% 
% delta_eff_sen = 1;
% delta_eff_lat = 1;



% while abs(delta_eff_sen)> 0.01 | abs(delta_eff_lat)> 0.01

    
    
% for crossflow
% 
% delta_eff_sen = eff_sen - eff_sen_step
% delta_eff_lat = eff_lat - eff_lat_step
% 
% if delta_eff_sen > 0.01
%     NTU_sen = NTU_sen + 0.0001
% elseif delta_eff_sen < 0.01
%     NTU_sen = NTU_sen - 0.0001
% end
% 
% if delta_eff_lat > 0.01
%     NTU_lat = NTU_lat + 0.0001
% elseif delta_eff_lat < -0.01
%     NTU_lat = NTU_lat - 0.0001
% end

% eff_sen_step = 1 - exp((exp(-R_f*NTU_sen^0.78)-1)/(R_f*NTU_sen^(-0.22)))
% eff_lat_step = 1 - exp((exp(-R_f*NTU_lat^0.78)-1)/(R_f*NTU_lat^(-0.22)))
% 
% end

% for counterflow

a =  size (T_AUL,1)
 x0 = ones (a,1)
 
 f = @(x)parameterfun_sen(x,R_f,eff_sen)
% x = fsolve(@myfun,x0);
% [x,fval] = fsolve(f,x0);
[x,fval,exitflag,output,jacobian] = fsolve(f,x0);

NTU_sen = x;
%k1 = NTU_sen/(m_strom_f*A)

%k in [KW/K/m²]


k_sen = NTU_sen .* W_f ./ A;
%end


y0 = ones(a,1);

    f_lat = @(y)parameterfun_lat(y,R_f,eff_lat);
    
    [y,fval_lat,exitflag_lat,output_lat,jacobian_lat] = fsolve(f_lat,y0);

NTU_lat = y;
k_lat = NTU_lat.*W_f./A;

end