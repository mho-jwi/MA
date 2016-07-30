clear all;

% Stoffdaten Luftstrom
% Waermekapazitaet [kJ/kg/K]
cp_f = 1.005;
cp_e = 1,005;

% Anlagendaten
% Membranfläche [m²]
A = 100

% Betriebsbedingungen
% Temperaturen [°C]
Tfi = 10;
Tfo = 20;
Tei = 23;
Teo = 13;

% Massenstroeme Luft [kg/h] 
m_strom_f = 20;
m_strom_e = 20;

% Dimensionslose Temperaturen
dimlT_f = (Tfi - Tfo)/ (Tfi - Tei);
dimlT_e = (Teo - Tei)/ (Tfi - Tei);

% Waermekapazitaetsstrom [kJ/K]
W_strom_f = cp_f * m_strom_f;
W_strom_e = cp_e * m_strom_e;

% Kapazitaetsstromkoeffizient
R_f = W_strom_f/W_strom_e;
R_e = W_strom_e/W_strom_f;

% Number of Transferunits für reine Gegenstromübertrager
NTU_f = 1/(1-R_f)*log((1-R_f*dimlT_f)/(1-dimlT_f));

% Waermeuebertragungskoeffizient [kJ/kg/K]
k = NTU_f * W_strom_f * A;

