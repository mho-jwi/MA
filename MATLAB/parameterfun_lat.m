function F = parameterfun_lat(y,R_f,eff_lat)

F = [1.*R_f./R_f - exp((exp(-R_f.*y.^0.78)-1.*R_f./R_f)./(R_f.*y.^(-0.22)))-eff_lat];
end

