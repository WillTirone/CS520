% demo_root_extraction.m
% objectives 
%  iteration with linear rate convergence 
%  iteration with quadratic rate convergence 
% 

close all 
clear all


alpha = 1/2;
mu    = -1;
x0    = 1/2;
imax  = 10;

[xlinear, res1 ]  = square_root_linear( alpha, x0, mu, imax  ) ;

figure 
yyaxis left 
plot(1:imax, xlinear(1:imax), 'b*');
ylabel('iterate')
yyaxis right 
semilogy(1:imax, abs(res1(1:imax)), 'ro-.');
ylabel('residual')
title('Stationay (linear) iteration')

% ===========================================================

imax = 6; 
[xquadratic, res2]  = square_root_newton( alpha, x0, imax ) ;

figure 
yyaxis left 
plot(1:imax, xquadratic(1:imax), 'b*');
ylabel('iterate')
yyaxis right 
semilogy(1:imax, abs(res2(1:imax)), 'ro-.');
ylabel('residual')
title('Ralph-Newton Iteration')
% =========================================================

function [x, r]  = square_root_linear( alpha, x0, mu, imax  ) 
% 
% alpha : (0,1/2)    
% mu: parameter for feedback control 
% 
% x : square root x^2 = alpha 

x(1) = x0;
for i = 1:imax 
  r(i)   = x(i)^2 - alpha; 
  x(i+1) = x(i) + mu * r(i) ;
end 

end % square_root_linear 

% ==============================================================

function [x,r] = square_root_newton( alpha, x0, imax ) 

x(1) = x0;
for i = 1:imax 
  r(i)   = x(i)^2 - alpha; 
  x(i+1) = x(i) - 0.5* r(i)/x(i) ;
end 

end % square_root_newton 



%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
%% 