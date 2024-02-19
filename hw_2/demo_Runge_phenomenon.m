% demo_Runge_phenomenon.m 
% at equispaced nodes for training
% max errors increases with the degree 
% 

clear all
close all

nhmax  = 19;
nhmin  = 2;
hstep  = 2;
neval  = 100+1;

np    = length( nhmin:hstep:nhmax); 
Y     = zeros(neval, np); 

xeval = linspace(-1,1,neval);
yeval = Runge(xeval);

k = 1; 
nk = zeros(np,1); 
for n = nhmin:hstep:nhmax 

  xk  = linspace(-1,1,2*n+1)'; 
  yk = Runge(xk); 
  
  pk     = polyfit(xk,yk, 2*n-1); 
  nk(k)  = 2*n ;
  Y(:,k) = polyval( pk, xeval );  

  k = k+1; 
end

%% 
figure('Name', 'Runge Phenomenon')
gp = 2; gq = ceil(np/2);
for k = 1:np 
  subplot( gp, gq, k) 
  plot( xeval, yeval, 'b-.');
  hold on 
  plot( xeval, Y(:,k), 'r-.');
  hold off 
  title(sprintf('degree %d', nk(k) )); 
end

%% programmer 
%  Xiaobai Sun 
%  Feb. 2024 
% 