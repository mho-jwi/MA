function F = parameterfun_lat(y,R_f,eff_lat)
einvec = ones(size(R_f,1),1);
F = [1*einvec - exp((exp(-R_f.*y.^0.78)-1*einvec)./(R_f.*y.^(-0.22)))-eff_lat];
end

