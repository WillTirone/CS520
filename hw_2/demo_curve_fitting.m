% demo_curve_fitting.m
close all
clear all

fprintf('\n\n   %s began \n', mfilename);

%% ... preview the curve 

fprintf('\n   preview of a 3D curve' );
t  = linspace(-1,1,200);

fig_flag = 1; 
[xt, yt, zt ] = get_curve3D (t, fig_flag)  ; 
fig_flag = 0;

%% ... set a emall trianingset  

fprintf('\n   choose a small training set' );
n = 30;
m  = n+1;

t  = (1:m)-1/2;              % mid-points 
t  = t(m:-1:1);
t  = cos( t * pi/m );        % a half circle (one pi)   


[xt, yt, zt] = get_curve3D (t, fig_flag)  ; 


%% ... set DoFs with polynomial fitting 

% ..  exact if n = m-1, approximated and regulated if n < m-1 

fprintf('\n   make exact fitting ... ' );

fx_fit_type = 'cubicspline';
fy_fit_type = 'fourier3';
fz_fit_type = 'fourier3';

[fx, ~] = fit(t',  xt, fx_fit_type);
[fy, ~] = fit(t', yt, fy_fit_type);
[fz, ~] = fit(t', zt, fz_fit_type);

%% .. reconstruct the training points 

xt_r = feval(fx, t); 
yt_r = feval(fy, t);
zt_r = feval(fz, t);

fprintf('\n   show the fitting at the training set ... ' ); 

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

xtq_p = feval(fx,tq);          
ytq_p = feval(fy,tq); 
ztq_p = feval(fz,tq); 

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
