% demo_Runge_adaptive_sampling
% 

clear all
close all

fprintf('\n\n   %s began \n', mfilename );

%% ... prescribed conditions on adaptation 

rtau  = 0.005;
nmax  = 35 ;

%% ... initial sampling and fitting 

fprintf('\n   initial sample set and Runge fitting ... ');
nmin  = 7; 
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

%% ... display initial fitting 

xfine = linspace(-1,1,100);
yfine = Runge(xfine); 

figure 
plot( xk, yk, 'bx', xkmid, ykmid,  'bx')
hold on 
plot( xk, pvalk, 'ro',  xkmid, pvalkmid, 'ro');
plot( xfine, yfine, 'k-.'); 
hold off 

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

%% ... show the result of adaptive sampling and fitting 

figure('Name','adaptive sampling-fitting')
plot( xk, yk, 'bx', xkmid, ykmid,  'bx')
hold on 
plot( xk, pvalk, 'ro', xkmid, pvalkmid, 'ro');
plot( xfine, yfine, 'k-.'); 
hold off 
deg_rmax = sprintf( 'degree %d, rmax=%1.3f', n-1, rkmax );
title( ['Adaptive sampling-fitting: ', deg_rmax ] ); 

%% ... compare the adaptive nodes with Chebyshev nodes 

fprintf('\n   comparing three types of nodes ... ');
t  = (1:n)-1/2;               % mid-points 
t  = t(n:-1:1);               % reverse the ordering 
ck = cos( t * pi/n );         % cosine mapping -- Chebyshev nodes 

figure('name', 'comparison in node sets') 
plot(1:n, linspace(-1,1,n), 'kx');
hold on 
plot( 1:n, ck, 'b+', 1:n, ck, 'mo'); 
hold off 
legend('black - equi-spaced nodes', ... 
       'magenta - Chebyshev nodes', ... 
       'blue - adaptive nodes', ... 
       'Location', 'best'); 
title('Three node sets: equi-splaced, Chebyshev, adaptive');

%% 

fprintf('\n\n   %s finished \n\n', mfilename); 
return 

%% programmer 
%  Xiaobai Sun 
%  Feb. 2024 
% 