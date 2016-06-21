function F = myfunc(x)
F = [1 - exp((exp(-R_f*x.^0.78)-1)/(R_f*x.^(-0.22)))-eff_sen];
end