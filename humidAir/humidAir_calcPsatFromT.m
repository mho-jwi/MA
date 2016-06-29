function [ pSat ] = humidAir_calcPsatFromT(Tgas)
%calculates saturation pressure of humid air from 
% temperature in °C
% 
%saturation pressure is returned in Pa

% Magnus Equation from: http://www.schweizer-fn.de/lueftung/feuchte/feuchte.php
        pSat = 611.2 * exp((17.62 * Tgas) / (243.12 + Tgas));
                
 % return value in Pa

end