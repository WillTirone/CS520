function [ xt, yt, zt]  = get_curve3D(t, fig_flag)
% 
%  [xt, yt, zt] = get_curve3D(t, fig_flag );
% 
%   t: vector of n points between [-1,1] 

t = t(:);      % column vector 


% .. curve model and parameters 

cx = 1; 
cy = 2;
wx = 4;
wy = 9;

xt = 4./ (1 + 25*t.^2 ) ;             % It is the Runge function 
yt = 1 + 2 * cos( cx + wx * t ); 
zt = 2 + sin( cy + wy * t ) ; 



%% .. plot the points on the curve 

if fig_flag 

figure('Name', 'dot curve') 
plot3( xt, yt, zt ,'bx-');
hold on 
subidx = [1,length(t)];
plot3( xt(subidx), yt(subidx), zt(subidx), 'ro'); 
hold off 
% 
grid on; box on 
xlabel('X'); 
ylabel('Y');
zlabel('Z');
title('Points on a 3D curve')

figure('Name','curve components') 
subplot(3,1,1)
plot(t, xt, 'b+-'); ylabel('x')
title('component/coordinate functions') 
% 
subplot(3,1,2)
plot(t, yt, 'k+-'); ylabel('y') 
% 
subplot(3,1,3)
plot(t, zt, 'mx-'); xlabel('z')
xlabel('t:curve variable')


end 

return 

%% Programmer 
%% Xiaobai Sun
%% 