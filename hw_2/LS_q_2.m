%%
% =========================================================================
% EQUISPACED POINTS =======================================================
% =========================================================================

mh = 15;    
m  = 2*mh + 1;
t  = linspace(-1, 1, m);

fig_flag = 0; 
[xt, yt, zt ] = get_curve3D (t, fig_flag)  ; 

%% set DoFs with polynomial fitting 

% ..  exact if n = m-1, approximated and regulated if n < m-1 
n  = 9;                         % set the dimension (DoF) lower 

nx = n;                         % DoF for each coordinate 
ny = n;
nz = n; 

px = polyfit(t, xt, nx);
py = polyfit(t, yt, ny);
pz = polyfit(t, zt, nz); 

%% .. interpolating at query points : test 

% test set, mid points among t 
tq = (t(2:m) + t(1:m-1))/2 ; 

% evaluating the polynomials at tq
xtq_p = polyval(px, tq);          
ytq_p = polyval(py, tq); 
ztq_p = polyval(pz, tq); 

[xtq, ytq, ztq] = get_curve3D( tq, fig_flag );   % get the ground truth 
%% 

figure('Name','LS equi-spaced points fitting') 
% 
subplot(3,1,1) 
plot( t, xt, 'bx'); 
ylabel('x')  
hold on 
plot( tq, xtq,   'bx'); 
plot( tq, xtq_p, 'ro'); 
hold off 
% 
subplot(3,1,2) 
plot( t, yt, 'kx'); 
ylabel('y')  
hold on 
plot( tq, ytq,   'kx'); 
plot( tq, ytq_p, 'ro'); 
hold off 
% 
subplot(3,1,3) 
plot( t, zt, 'bx'); 
ylabel('z')  
hold on 
plot( tq, ztq,   'bx'); 
plot( tq, ztq_p, 'mo'); 
hold off 
% 

% Add a title to the figure
% code to add a title from chatGPT
sgtitle('LS Fitting with Equispaced Nodes');

% Save the figure
print('LS_Fitting_with_Equi_Nodes.jpg', '-djpeg', '-r300');

%%
% =========================================================================
% CHEBYSHEV POINTS =======================================================
% =========================================================================

m = 30;
t  = (1:m)-1/2;      
t  = t(m:-1:1);
t  = cos(t * pi/m );         

fig_flag = 0; 
[xt, yt, zt ] = get_curve3D (t, fig_flag)  ; 

%% set DoFs with polynomial fitting 

% ..  exact if n = m-1, approximated and regulated if n < m-1 
n  = 9;                         % set the dimension (DoF) lower 

nx = n;                         % DoF for each coordinate 
ny = n;
nz = n; 

px = polyfit(t, xt, nx);
py = polyfit(t, yt, ny);
pz = polyfit(t, zt, nz); 

%% .. interpolating at query points : test 

% test set, mid points among t 
tq = (t(2:m) + t(1:m-1))/2 ; 

% evaluating the polynomials at tq
xtq_p = polyval(px, tq);          
ytq_p = polyval(py, tq); 
ztq_p = polyval(pz, tq); 

[xtq, ytq, ztq] = get_curve3D( tq, fig_flag );   % get the ground truth 
%% 

% 
figure('Name', 'LS Fitting with Chebyshev Nodes');
subplot(3,1,1) 
plot( t, xt, 'bx'); 
ylabel('x')  
hold on 
plot( tq, xtq,   'bx'); 
plot( tq, xtq_p, 'ro'); 
hold off 
% 
subplot(3,1,2) 
plot( t, yt, 'kx'); 
ylabel('y')  
hold on 
plot( tq, ytq,   'kx'); 
plot( tq, ytq_p, 'ro'); 
hold off 
% 
subplot(3,1,3) 
plot( t, zt, 'bx'); 
ylabel('z')  
hold on 
plot( tq, ztq,   'bx'); 
plot( tq, ztq_p, 'mo'); 
hold off 
% 

% Add a title to the figure
% code to add a title from chatGPT
sgtitle('LS Fitting with Chebyshev Nodes');

% Save the figure
print('LS_Fitting_with_Chebyshev_Nodes.jpg', '-djpeg', '-r300');

%%
% =========================================================================
% ADAPTIVE POINTS =======================================================
% =========================================================================

%% ... prescribed conditions on adaptation 

% high enough tolerance or low enough degree will give us a poly probably
rtau  = 0.25;
nmax  = 30;

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
  pk    = polyfit(xk, yk, n-1); 
  pvalk = polyval( pk, xk );

  xkmid  = (xk(1:end-1) + xk(2:end))/2 ;  % test at mid points 
  ykmid  = Runge( xkmid);

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
title( ['LS Adaptive Sampling-fitting: ', deg_rmax ] ); 

% Save the figure
print('LS_Fitting_with_Adaptive_Nodes.jpg', '-djpeg', '-r300');
