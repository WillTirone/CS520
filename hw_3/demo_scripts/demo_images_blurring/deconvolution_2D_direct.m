function Y = deconvolution_2D_direct( B, T1, T2) 
%
%  Y = deconvolution_2D_direct( B, T1, T2); 
% 
% Input 
% =====
%  B: image blurred by separable circulant convolutions 
%  T1, T2: circulant convolution matrices in explicit form 
% Output
% ======

B1 = T1\B; 
Y  = B1/T2;                            %   Y = inv(T1) * B * inv(T2 ); 

return 

%% Programmer 
%  Xiaobai Sun 
%  Duke CS 
% 