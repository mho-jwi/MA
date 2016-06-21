R_f = 0.7;
eff_sen = 0.9;


%x0 = [-0.01,0.01];
 x0 = [x];


 
 f = @(x)parameterfun(x,R_f,eff_sen);
% x = fsolve(@myfun,x0);
% [x,fval] = fsolve(f,x0);
[x,fval] = fsolve(f,x0);