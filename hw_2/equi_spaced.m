% demo_curve_fitting.m 
function max_error = equi_spaced(n)

fprintf('\n\n   %s began \n', mfilename);

%% ... set a emall trianingset  

fprintf('\n   train on set based on n' );

m  = n+1;
t  = linspace(-1,1,m);

fig_flag = 0;
[xt, yt, zt ] = get_curve3D (t, fig_flag)  ; 

%% ... set DoFs with polynomial fitting 

% ..  exact if n = m-1, approximated and regulated if n < m-1 

fprintf('\n   make exact fitting ... ' );

nx = n;                         % DoF for each coordinate 
ny = n;
nz = n; 

px = polyfit(t,xt, nx);
py = polyfit(t,yt, ny);
pz = polyfit(t,zt, nz); 

%% .. reconstruct the training points 

xt_r = polyval(px,t );   
yt_r = polyval(py,t ); 
zt_r = polyval(pz,t ); 


%% .. interpolating at query points : test 

fprintf('\n   calculating the maximum error based on a test set ... ' );

tq = ( t(2:m) + t(1:m-1))/2 ;    % mid points among t 

xtq_p = polyval(px,tq);          
ytq_p = polyval(py,tq); 
ztq_p = polyval(pz,tq); 

fig_flag = 0; 
[ xtq, ytq, ztq] = get_curve3D( tq, fig_flag );   % get the ground truth


%% ... calculating max error
max_error = -Inf;
for test_point = 1:length(xtq_p)
    error = abs(xtq(test_point) - xtq_p(test_point)) + abs(ytq(test_point) - ytq_p(test_point)) + abs(ztq(test_point) - ztq_p(test_point));
    if error > max_error
        max_error = error;
    end
end



%%
fprintf('\n\n   %s ended \n\n', mfilename);


return 
