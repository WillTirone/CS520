% chevyshev_spaced.m
function max_error = chebyshev_spaced(n)

close all

fprintf('\n\n   %s began \n', mfilename);


%% ... get the Chebyshev nodes 
fprintf('\n getting chebyshev nodes for training')

m = n+1;

t  = (1:m)-1/2;              % mid-points 
t  = t(m:-1:1);
t  = cos( t * pi/m );        % a half circle (one pi)                  

fig_flag = 0;
[ xt, yt, zt ] = get_curve3D ( t, fig_flag)  ; 

%% ... set DoFs with polynomial fitting 

% ..  exact if n = m-1, approximated and regulated if n < m-1 

fprintf('\n   make exact fitting at Chebyshev nodes .. ' );

nx = n;                         % DoF for each coordinate 
ny = n;
nz = n; 

[ px ]  = polyfit( t, xt, nx);
[ py ]  = polyfit( t, yt, ny);
[ pz ]  = polyfit( t, zt, nz); 


%% .. interpolating at query points : test 

fprintf('\n   show the fitting/misfitting at a test set ... ' );

tq = ( t(2:m) + t(1:m-1))/2 ;    % mid points among t 

xtq_p = polyval( px, tq );          
ytq_p = polyval( py, tq ); 
ztq_p = polyval( pz, tq ); 

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

