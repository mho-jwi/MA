%function [NTU_lat,NTU_sen] = Waerme_Stofftransportmodell_Enthalpietauscher()
% Modell Feuchtetransport Enthalpietauscher
excel_read;

% Stoffdaten Luftstrom
% Waermekapazitaet [kJ/kg/K]
cp_f = 1.005;
cp_e = 1,005;

% Anlagendaten
% Membranfläche [m²]
A = 100;

% % Betriebsbedingungen
% % Temperaturen [°C]
% T_fi = [10;11];
% T_fo = [20;21];
% T_ei = [23;24];
% T_eo = [13;14];

% % Feuchtebeladungen [kg/kg]
% phi_fi = [1;1.1];
% phi_fo = [4;4.1];
% phi_ei = [5;5.1];
% phi_eo = [2;2.1];
% 
% % Massenstroeme Luft [kg/h] 
% m_strom_f = [20;21];
% m_strom_e = [20;21];

% % Kapazitaetsstromkoeffizient
R_f = m_strom_f.*cp_f./m_strom_e.*cp_e;
% R_e = m_strom_e*cp_e/m_strom_f*cp_f;

W_f = m_strom_f.*cp_f;
W_e = m_strom_e.*cp_e;


% effectiveness
% sensibel
eff_sen = (m_strom_f .* cp_f .* (T_fi-T_fo))./ (min(W_f,W_e).*(T_fi-T_ei))

% latent
 eff_lat = (m_strom_f .*  (phi_fi-phi_fo))./ (min(m_strom_f,m_strom_e).*(phi_fi-phi_ei))


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

a =  size (T_fi,1)*0.1+0.9;
 x0 = [1:0.1:a]';
 
 f = @(x)parameterfun(x,R_f,eff_sen);
% x = fsolve(@myfun,x0);
% [x,fval] = fsolve(f,x0);
[x,fval,exitflag,output,jacobian] = fsolve(f,x0);

NTU_sen = x;
%k1 = NTU_sen/(m_strom_f*A)
k = NTU_sen .* W_f .* A;
%end


y0 = [1:0.1:a]';

    f_lat = @(y)parameterfun_lat(y,R_f,eff_lat);
    
    [y,fval_lat,exitflag_lat,output_lat,jacobian_lat] = fsolve(f_lat,y0);

NTU_lat = y;
k_lat = NTU_lat.*W_f.*A;