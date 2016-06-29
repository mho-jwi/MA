function [ pSat ] = humidAir_calcPsatFromRhXpAmb(rh, x, pAmb )
% calculates saturation pressure of humid air from 
% relative humidity (%)
% mass fraction of water (kg/kg) in dry air
% ambient pressure in Pa
% 
%saturation pressure is returned in Pa


    pSat = (x  / (0.622 + x )) * pAmb / (rh/100);

end

