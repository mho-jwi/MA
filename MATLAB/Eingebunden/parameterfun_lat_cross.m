function F = parameterfun_sen_cross(x,R_f,eff_lat,faccounta,faccountb)


F = [1/(R_f*y) * (1- exp(-y)*faccounta) * (1-exp(-R_f*y)*faccountb) - eff_lat];

end

