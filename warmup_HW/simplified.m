% 
% demo_bifurcation_diagram
% SCRIPT 
% generating a bifurvation diagram for quadratic recurrence maps 
% -- set the parameters 
% -- compute the data matrix over a parameter grid 
% -- plot the bifurcation diagram 
% -- plot some cross sections 

close all
clear all 

tic;

fprintf('\n\n   Begin of %s ...  \n\n', mfilename);

%% ... Parameter setting and variation for investigative study 

rmin =  2.8;              % set a finite r-range between -2 and 4 
rmax =  4 ;              
dr   =  0.01;             % set the r-spacing resolution 

x0       = 0.7;           %  the initial value 
maxsteps = 2000;          %  vs. 1000; #recurrence steps to take at each value of r 
steps_transient = 300;    %  vs. 30;   #transient steos to skip
steps_asymp = maxsteps-steps_transient ; % far-future steps to record 

%% ===== no or little change below ==================================

nrs      = floor( (rmax-rmin)/dr );      % equi-spaced r-values 
r_values = linspace( rmin, rmax, nrs ); 

% Generate data matrix
M = operation_matrix_generator(x0, r_values, steps_transient, steps_asymp);

%% ==================================================================

%% ... visual inspection and investigation 

isteps = steps_transient +(1:steps_asymp)';  

% Stop the timer
elapsed_time = toc;

% Display the elapsed time
fprintf('Elapsed time: %f seconds\n', elapsed_time);


fprintf('\n   plotting bifurcation diagram and the matrix ... ');

figure( 'name','Bifurcation Diagram (dots) ')
% 
plot( r_values, M, 'b+', 'MarkerSize', 1); 
% NOTE: do not use line interplation nor colorcodes in matlab 
%       which create misleading artifacts 
xlabel('r');
ylabel('x');
axis tight
title('bifurcation diagram for quadratic recurrence')
% NOTE: do not use line interplation nor colorcodes in matlab 
%       which create misleading artifacts 

figure( 'name', 'Bifurcation Diagram Matrix') 
% 
imagesc(M); colorbar ;
colormap('jet')
colorbar 
xlabel('r'); 
ylabel('step i'); 
title('The x-matrix over parameter grid')


%%
fprintf('\n   plotting the recurrence sequence at a single r-value ...')

figure 
% 
subplot(3,1,1) 
jseg = floor( nrs/4); 
j1 = 50; 
plot(isteps, M(:, j1), 'b+', 'Markersize', 2); 
ylabel(sprintf('x(i) at r=%0.2f', r_values(j1))); 
title('recurence sequence at a particular r-value')
%
subplot(3,1,2)
j2 = j1 + jseg; 
plot(isteps, M(:, j2), 'b+', 'Markersize', 2); 
ylabel(sprintf('x(i) at r=%0.2f', r_values(j1))); 
subplot(3,1,3)
j3 = j2 + jseg; 
plot(isteps, M(:, j3), 'b+', 'Markersize', 2); 
xlabel('step i'); 
ylabel(sprintf('x(i) at r=%0.2f', r_values(j1))); 


%%
fprintf('\n   plotting L^{k}(x_0) across r-values at fixed step k ...');

figure 
% 
subplot(3,1,1) 
kseg = floor(steps_asymp/4); 
k1 = 50 + steps_transient; 
plot( r_values, M(k1, :), 'mx', 'Markersize', 2); 
ylabel(sprintf('x(%d, :)', k1)); 
title('x(k,r-values) at particular k values')
subplot(3,1,2)
k2  = k1 + kseg; 
plot( r_values, M(k2, :), 'mx', 'Markersize', 2); 
ylabel(sprintf('x(%d, :)', k2)); 
subplot(3,1,3)
k3 = k2 + kseg;
plot( r_values, M(k3, :), 'mx', 'Markersize', 2); 
ylabel(sprintf('x(%d, :)', k3)); 
xlabel('r values'); 

%%
fprintf('\n\n   End of %s ! \n\n', mfilename);

return 

%% ... the following does not portrait well as expected 

figure( 'name', 'Bifurcation Diagram Matrix as 3D surface') 
[Rx,Ix] = meshgrid( r_values, isteps);
% surf( Rx, Ix, M, 'EdgeColor','none'); 
surf( Rx, Ix, M, M.^2, 'EdgeColor','none');  
colormap("jet"); 
zlabel('x')
xlabel('r'); 
ylabel('step i'); 
view(-10,10);

%%
%%% see version v0 by ChatGPT 
%%% corrected and modified by Xiaobai Sun  
%%% Jan. 10, 2024 