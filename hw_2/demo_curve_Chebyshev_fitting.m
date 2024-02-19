% demo_curve_Chebyshev_fitting.m 

close all
clear all

fprintf('\n\n   %s began \n', mfilename);

%% ... preview the curve 

fprintf('\n   preview of a 3D curve' );
t  = linspace(-1,1,200);

fig_flag = 1; 
[ xt, yt, zt ] = get_curve3D (t, fig_flag)  ; 
fig_flag = 0;

%% ... set a emall trianingset  

fprintf('\n   choose a small training set' );

m  = 30; 

%% ... get the Chebyshev nodes 

t  = (1:m)-1/2;              % mid-points 
t  = t(m:-1:1);
t  = cos( t * pi/m );        % a half circle (one pi)                  

[ xt, yt, zt ] = get_curve3D ( t, fig_flag)  ; 

%% ... set DoFs with polynomial fitting 

% ..  exact if n = m-1, approximated and regulated if n < m-1 

fprintf('\n   make exact fitting at Chebyshev nodes .. ' );

n  = m-1; 

nx = n;                         % DoF for each coordinate 
ny = n;
nz = n; 

[ px ]  = polyfit( t, xt, nx);
[ py ]  = polyfit( t, yt, ny);
[ pz ]  = polyfit( t, zt, nz); 

%% .. reconstruct the training points 

xt_r = polyval( px, t );   
yt_r = polyval( py, t ); 
zt_r = polyval( pz, t ); 

fprintf('\n   show the fitting at the Chebyshev nodes  ... ' ); 

figure('Name','point reconstruction')
plot3( xt,   yt,   zt,   'bx'); 
hold on 
plot3( xt_r, yt_r, zt_r, 'ro'); 
hold off 
legend('blue for ground truth','red for reconstruction')
title('data point reconstruction') 
grid on; box on 

%% .. interpolating at query points : test 

fprintf('\n   show the fitting/misfitting at a test set ... ' );

tq = ( t(2:m) + t(1:m-1))/2 ;    % mid points among t 

xtq_p = polyval( px, tq );          
ytq_p = polyval( py, tq ); 
ztq_p = polyval( pz, tq ); 

fig_flag = 0; 
[ xtq, ytq, ztq] = get_curve3D( tq, fig_flag );   % get the ground truth 

%% 
figure('Name','nterpolating the components') 
% 
subplot(3,1,1) 
plot( t, xt, 'bx'); 
ylabel('x')  
hold on 
plot( tq, xtq,   'bx'); 
plot( tq, xtq_p, 'ro'); 
hold off 
title('interpolating the curve components')
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

%% ... show the interpolation matrix 

fprintf('\n   show the image of the interpolation matrix ')
Vc = fliplr( vander(t) ); 

figure 
imagesc( sign(Vc) .* log2( eps + abs(Vc) )  ) 
colormap( flipud( jet(8) ) );
title('the interpolation matrix (quantized in log scale)')
colorbar

%% 
fprintf('\n\n   %s ended \n\n', mfilename);


return 

%% notes: 
% The centralization and scaling counteract the effect of Chebyshev
% [ px, ~, xmu ]  = polyfit(t,xt, nx);
% [ py, ~, ymu ]  = polyfit(t,yt, ny);
% [ pz, ~, zmu ]  = polyfit(t,zt, nz); 

%% Programmer 
% Xiaobai Sun 
% Feb. 2024 
% 