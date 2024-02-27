% runge_adaptive_sampling.m
function xk = runge_adaptive_sampling(n)

fprintf('\n\n   %s began \n', mfilename );

%% ... prescribed conditions on adaptation 

rtau  = 0.005;
nmax  = n ;

%% ... initial sampling and fitting 

fprintf('\n   initial sample set and Runge fitting ... ');
nmin  = 5; 
n     = nmin; 
xk    = linspace(-1,1,n) ; 
yk    = Runge(xk); 

pk    =  polyfit(xk,yk,n-1); 
pvalk = polyval (pk, xk );

xkmid  = ( xk(1:end-1) + xk(2:end) )/2 ; 
ykmid  = Runge( xkmid );

pvalkmid  = polyval( pk, xkmid );

rk  = abs( pvalkmid - ykmid );      % residual at the test points 
[ rkmax, ik ] = max(rk); 


%% ... adaptive steps  

fprintf('\n   adaptive sampling and Runge fitting ... '); 

while rkmax > rtau && n < nmax    % termination conditions 
  
  xi1 = xkmid(ik);
  xi2 = -xi1;
  xk = sort( [ xi1, xk, xi2 ], "ascend"); 
  yk = Runge( xk );

  n     = n + 2; 
  pk    = polyfit(xk,yk,n-1); 
  pvalk = polyval( pk, xk );

  xkmid  = ( xk(1:end-1) + xk(2:end) )/2 ;  % test at mid points 
  ykmid  = Runge( xkmid );

  pvalkmid  = polyval( pk, xkmid );

  rk  = abs( pvalkmid - ykmid ); 
  [ rkmax, ik ] = max(rk);

end



%% 

fprintf('\n\n   %s finished \n\n', mfilename); 
return 

%% programmer 
%  Xiaobai Sun 
%  Feb. 2024 
% 