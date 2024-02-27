% adaptive_spaced.m
function max_error = adaptive_spaced(n)


fprintf('\n\n   %s began \n', mfilename);

fig_flag = 0;
t = runge_adaptive_sampling(n);
[xt, yt, zt ] = get_curve3D (t, fig_flag);

px = polyfit(t, xt, n);
py = polyfit(t, yt, n);
pz = polyfit(t, zt, n);


%% .. interpolating at query points : test 

fprintf('\n   calculating the maximum error based on a test set ... ' );

m = length(t);

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
