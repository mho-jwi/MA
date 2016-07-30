function [PHI_ABL, PHI_AUL, PHI_FOL, PHI_ZUL] = Berechnung_relative_Feuchte_aus_Spannung(PHI_ABL, PHI_AUL, PHI_FOL, PHI_ZUL, T_ABL, T_AUL, T_FOL_PHI, T_ZUL_PHI, Spannung);
%die realtive Feuchte wird in % errechnet
%die Temperaturen werden in °C verwendet
%die Spannung und die PHI-Messwerte sind in V dokumentiert
 
einvec = ones(size(PHI_ABL,1),1);

% % errechnen der relativen Feuchte aus der gemessenen Spannung bei 25°C
% RH_ABL = ((PHI_ABL./Spannung)-0.16*einvec)/0.0062;
% RH_AUL = ((PHI_AUL./Spannung)-0.16*einvec)/0.0062;
% RH_FOL = ((PHI_FOL./Spannung)-0.16*einvec)/0.0062;
% RH_ZUL = ((PHI_ZUL./Spannung)-0.16*einvec)/0.0062;

RH_ABL = -19.5443*einvec+140.1771*PHI_ABL./Spannung;
RH_AUL = -20.8998*einvec+142.8568*PHI_AUL./Spannung;
RH_FOL = -20.3331*einvec+142.4142*PHI_FOL./Spannung;
RH_ZUL = -19.3049*einvec+140.3262*PHI_ZUL./Spannung;

%errechnen Temperaturkorregierten relativen Feuchte
PHI_ABL = RH_ABL./(1.0546*einvec-0.00216*T_ABL);
PHI_AUL = RH_AUL./(1.0546*einvec-0.00216*T_AUL);
PHI_FOL = RH_FOL./(1.0546*einvec-0.00216*T_FOL_PHI);
PHI_ZUL = RH_ZUL./(1.0546*einvec-0.00216*T_ZUL_PHI);

clear RH_ABL RH_AUL RH_FOL RH_ZUL;
end