function Enthalpy_humidAir = humidAir_calcEnthalpy( AirTemperature, relHumiAir , pAmbient)
%HUMIDAIR_CALCENTHALPY Returns enthalpy (h_1+x) in kJ/kg from humid air for rel.
%humidity <100%
%   PST: Quick hack to calc enthalpy of humid air, AirTemperature in °C,
%   relHumiAir in %, pAmbient in mbar/hPa
    if 0<= relHumiAir <= 100
        pSat_water = 611.2*exp((17.62*AirTemperature)/(243.12+AirTemperature));%Magnus Equation from: http://www.schweizer-fn.de/lueftung/feuchte/feuchte.php 
        load_water = 0.622*(pSat_water/((10000*pAmbient/relHumiAir)-pSat_water));
        Enthalpy_humidAir = AirTemperature + load_water*(2500+1.86*load_water);
    end
end

