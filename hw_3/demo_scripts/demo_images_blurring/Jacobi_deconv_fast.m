function X = Jacobi_deconv_fast( Xf, f, imax, X0  )
% Jacobi_deconv_fast( Xf, f, imax, X0);
% 
% Input
% -----
% Xf:  2D array convolved filter f 
% f:   filter, odd size in each dimension, the middle elemen is dominant 
% X0:  the initial guess 
% imax: integer, number of iterations 
% via:  boolean, if 1, visualize every imax/10 steps  
% 
% Output 
% ------
% X:   2D array, deconvolved 
% 
% The Jacobi iteration step is executed as a convolution step, 
% use CONV2 
% 


% ... make the Jacobi filter for deconvolution '

wsize = size(f,1);
pc    = (wsize+1)/2; 
dc    = f(pc,pc); 

Jacobi = -f/dc;
Jacobi(pc,pc) = 0;

%% ... iterative deconvolution with the Jacobi iteration 

Brhs = Xf/dc;          % the right hand side 
Xi   = X0;          % the initial guess 

for i = 1: imax  
   
   % ... computing 
   Bi = conv2( Xi, Jacobi, 'same') + Brhs ;  % if separable, use conv2(u,v,Xi) 
   Xi = Bi;

end

X = Xi;

end 

%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
%% Asking the programmer's permission for any distribution 
%% 
