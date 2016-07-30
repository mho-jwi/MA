function F = parameterfun_sen_cross(x,R_f,eff_sen,faccounta,faccountb)
% R_f = [0.7];
% eff_sen = [0.9];
% a = R_f;
% b = eff_sen;
%x = [NTU_sen;R_f;eff_sen]

F = [1/(R_f*x) * (1- exp(-x)*faccounta) * (1-exp(-R_f*x)*faccountb) - eff_sen];

end

%clear a b; 
