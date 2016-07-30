function F = parameterfun(x,R_f,eff_sen)
% R_f = [0.7];
% eff_sen = [0.9];
% a = R_f;
% b = eff_sen;
%x = [NTU_sen;R_f;eff_sen]
einvec = ones(size(R_F,1),1);

F = [1*einvec - exp((exp(-R_f.*x.^0.78)-1*einvec)./(R_f.*x.^(-0.22)))-eff_sen];
end

%clear a b; 