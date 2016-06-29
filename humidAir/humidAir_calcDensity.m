function Density_humidAir = humidAir_calcDensity( AirTemperature, relHumiAir , pAmbient )
%DENSITY_HUMIDAIR Returns density (h_1+x) in kg/m³ from humid air for rel.
%humidity <100%
%   PST: Quick hack to calc density of humid air, AirTemperature in °C,
%   relHumiAir in %, pAmbient in mbar/hPa
    if 0<= relHumiAir <= 100
        pSat_water = 611.2*exp((17.62*AirTemperature)/(243.12+AirTemperature));%Magnus equation from: http://www.schweizer-fn.de/lueftung/feuchte/feuchte.php 
        %load_water = 0.622*(pSat_water/((10000*pAmbient/relHumiAir)-pSat_water));
        
        R_dryAir = 287.058;% J/(kg*K)
        R_steam = 461.51;% J/(kg*K)
        
        R_humidAir = R_dryAir/(1-(relHumiAir*pSat_water/(10000*pAmbient))*(1-(R_dryAir/R_steam)));
        
        Density_humidAir = 100*pAmbient/(R_humidAir*(AirTemperature + 273.15)); % ideal gas mixture: p=rho*R*T
    end
end

