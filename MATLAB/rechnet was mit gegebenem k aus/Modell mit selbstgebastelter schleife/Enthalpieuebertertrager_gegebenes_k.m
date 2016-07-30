% Stoffdaten Luftstrom
% Waermekapazitaet [kJ/kg/K]
cp_f = 1.005;
cp_e = 1,005;

% Anlagendaten
% Membranfläche [m²]
A = 100;
% k = a*T³ + b*T² + c*T + d
% a = 0,7;
% b = 1;
% c = 0,9;
% d = 20;


% Betriebsbedingungen
% Temperaturen [°C]
Tfi = 10;
Tfo = 20;
Tei = 23;
Teo = 13;

% Feuchtebeladungen [kg/kg]
phi_fi = 1;
phi_fo = 4;
phi_ei = 5;
phi_eo = 2;

% Massenstroeme Luft [kg/h] 
m_strom_f = 20;
m_strom_e = 20;

% % Kapazitaetsstromkoeffizient
R_f = m_strom_f*cp_f/m_strom_e*cp_e;
R_e = m_strom_e*cp_e/m_strom_f*cp_f;

W_f = m_strom_f*cp_f;
W_e = m_strom_e*cp_e;


% effectiveness
% sensibel
eff_sen = (m_strom_f * cp_f * (Tfi-Tfo))/ (min(W_f,W_e)*(Tfi-Tei))

% latent
eff_lat = (m_strom_f *  (phi_fi-phi_fo))/ (min(m_strom_f,m_strom_e)*(phi_fi-phi_ei))


%Zusammenhaenge zwischen NTU und effectiveness
NTU_sen = 1;
NTU_lat = 1;

eff_sen_step = 1 - exp((exp(-R_f*NTU_sen^0.78)-1)/(R_f*NTU_sen^(-0.22)));
eff_lat_step = 1 - exp((exp(-R_f*NTU_lat^0.78)-1)/(R_f*NTU_lat^(-0.22)));

delta_eff_sen = 1;
delta_eff_lat = 1;

%iteratives ermitteln von NTU über delta_eff

while abs(delta_eff_sen)> 0.01 | abs(delta_eff_lat)> 0.01

    
    
% for crossflow

delta_eff_sen = eff_sen - eff_sen_step
delta_eff_lat = eff_lat - eff_lat_step

if delta_eff_sen > 0.01
    NTU_sen = NTU_sen + 0.0001
elseif delta_eff_sen < 0.01
    NTU_sen = NTU_sen - 0.0001
end

if delta_eff_lat > 0.01
    NTU_lat = NTU_lat + 0.0001
elseif delta_eff_lat < -0.01
    NTU_lat = NTU_lat - 0.0001
end

eff_sen_step = 1 - exp((exp(-R_f*NTU_sen^0.78)-1)/(R_f*NTU_sen^(-0.22)))
eff_lat_step = 1 - exp((exp(-R_f*NTU_lat^0.78)-1)/(R_f*NTU_lat^(-0.22)))

end

% for counterflow

%k = k = a*T^3 + b*T^2 + c*T + d
k = NTU_sen * W_f * A;
%end