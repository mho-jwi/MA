clear all;

% Stoffdaten Luftstrom
% Waermekapazitaet [kJ/kg/K]
cp_f = 1.005;
cp_e = 1,005;

%Waermeuebertragungkoeffizient
k = 3000;

% Anlagendaten
% Membranfläche [m²]
A = 100

% Betriebsbedingungen
% Temperaturen [°C]
Tfi = 10;
Tei = 23;


% Massenstroeme Luft [kg/h] 
m_strom_f = 20;
m_strom_e = 20;

% Waermekapazitaetsstrom [kJ/K]
W_strom_f = cp_f * m_strom_f;
W_strom_e = cp_e * m_strom_e;

% Kapazitaetsstromkoeffizient
R_f = W_strom_f/W_strom_e;
R_e = W_strom_e/W_strom_f;

% Number of Transferunits
NTU_f = k/(W_strom_f * A);
NTU_e = k/(W_strom_e * A);

% dimlT für reinen Gegenstrom
dimlT_f = (1-exp((R_f-1)*NTU_f))/(1-R_f*exp((R_f-1)*NTU_f));
dimlT_e = (1-exp((R_f-1)*NTU_e))/(1-R_e*exp((R_e-1)*NTU_e));

% Berechnung Temperaturen

Tfo = Tfi - dimlT_f * (Tfi - Tei);
Teo =  Tei - dimlT_e* (Tfi - Tei);

