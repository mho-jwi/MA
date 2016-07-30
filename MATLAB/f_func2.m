
x0 = [1];

 options = optimoptions('fsolve','Display','iter');
 [x,fval] = fsolve(@myfun,x0,options)
% x=fsolve(@myfun,x0);
