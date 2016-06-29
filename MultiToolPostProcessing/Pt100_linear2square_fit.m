function T_corrected = Pt100_linear2square_fit( T_linear)
%Pt100_linear2square_fit corrects the measured temperature (ICP linear fit)
%into a square fit with higher accuracy
%   Input is the in a linear fit measured temperature in °C, Output 
alpha = 3.85e-03;
a = 3.9083e-03;
b = -5.775e-07;
T_corrected = ( -0.5* (a/b) )- sqrt( ( 0.5* (a/b) )^2 +( ( 1/b )*(alpha * T_linear) ) );
end

