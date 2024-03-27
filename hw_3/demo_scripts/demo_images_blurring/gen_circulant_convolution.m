function [c, r, T] = gen_circulant_convolution(n, b) 
% [c, r, T] = gen_circulant_convolution(n, b);
% 
% Input 
% =====
% n   the signal length 
% b   the convolution support, b <= n 
% Output
% ======
% c, r : the leading column and row of the circulant matrix 
%        for compressive representation 
% T    : the circument matrix in explicit form 
%        unweighted (can be changed into weighted) 
% 

kl = floor(b/2);              % half-bandwidth in the lower triangular 
ku = b - kl - 1 ;             % half-bandwidth in the upper triangular 

c = -[ ones(1+kl,1); zeros(n-(kl+ku+1),1) ; ones(ku,1) ];  % leading column
r = -[ ones(1+ku,1); zeros(n-(kl+ku+1),1) ; ones(kl,1) ];  % leading row 
c(1) = 2 ;                                                 % the diagonal element 
r(1) = 2 ; 

T = toeplitz(c,r);        % circulant matrix in explicit form  

end

%% programmer 
%  Xiaobai Sun 
%  Duke CS
