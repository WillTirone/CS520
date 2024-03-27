% demo_deconv_direct
% demo objectives 
%    direct solvers exploiting convolution kernel structures 
%    -- dimension separable ( parallel along each dimension ) 
%    -- if circulent in any dimension, use FFT along that dimension
% 
%    -- much faster than iterative 

close all 
clear all 

fprintf('\n\n   %s began ...\n',  mfilename );

%% ... load an image 

Igray = imread('peppers.png');
Igray = rgb2gray( Igray ); 
Igray = double( Igray ); 

[n1,n2] = size( Igray );  

%% ... create a circulant convolution kernel 

kl = 1; 
ku = 1; 

c1 = -[ ones(1+kl,1); zeros(n1-(kl+1),1) ];  % leading column
r1 = -[ ones(1+ku,1); zeros(n1-(ku+1),1) ];  % leading row 
c1(1) = 2;
r1(1) = 2; 

T1 = toeplitz(c1,r1);                                       % circulant matrix 
B  = T1*Igray ;

c2 = -[ ones(1+kl,1); zeros(n2-(kl+1),1) ];  % leading column
r2 = -[ ones(1+ku,1); zeros(n2-(ku+1),1) ];  % leading row 
c2(1) = 2;
r2(1) = 2; 

T2 = toeplitz(c2,r2);   
B  = B * T2; 

figure 
imagesc( B ) 
axis image 
colormap('gray')
title('blurred image')


%%  ... deconvoluion via brute force solver : high complexity 

fprintf('\n   deconvolution via general brute force direct solver ... ')

fprintf('\n   press a key to proceed ... ');
pause();


B1 = T1\B; 
Y  = B1/T2;        %   Y = inv(T1) * B * inv(T2 ); 

clear T1 T2 B1 

figure 
imagesc( Y )      
colormap('gray')
axis image 
title('2D DEconvolution by brute force direct solver');


%% ... (circulant) deconvition via FFT 

fprintf('\n\n   deconvolution via FFT  ... ') ;

fprintf('\n   press a key to proceed ... ');
pause();

r1hat  = fft(r1);    
minSigma1 = min(abs(r1hat)); 
if minSigma1 < 10*eps 
    fprintf('\n   T1 is near singular');
end 
kappa1 = max( abs(r1hat) )/minSigma1 ; 

r2hat  = fft(r2);    
minSigma2 = min(abs(r2hat)); 
if minSigma2 < 10*eps 
    fprintf('\n   T2 is near singular');
end 
kappa2 = max( abs(r2hat) )/minSigma2; 

fprintf('\n   cond #s: [kappa1, kappa2] = [ %0.2e, %0.2e] \n\n', kappa1, kappa2) ;

Bhat = fft(B.').' ;                                   
Bhat = ifft( Bhat ) ;                             
Xhat = diag(1./r1hat) * Bhat * diag(1./r2hat); 

X = fft( Xhat ); 
X = ifft( X.').'; 
X = real( X);


figure 
imagesc( X )
axis image 
colormap('gray'); 
title('2D circulant deconvolution via 2D FFT');

fprintf('\n\n   %s ended \n\n',  mfilename );

return 

%% 
%% Xiaobai Sun 
%% Duke CS 
%% Last revision: March 2023 
%% 