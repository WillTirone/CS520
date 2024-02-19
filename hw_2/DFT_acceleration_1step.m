% DFT_acceleration_1step.m 
% 
% Objective: 
%    > utilize the DFT factorization to accelerate DFT 
%    > compare the accuracy and efficiency 
%    > get familar with signal spectral and spatial profiles 
% 
% see also demo_DFT_factorization_1step.m 

clear all 
close all

fprintf('\n\n   %s began ... \n\n', mfilename );

k  = input('\n   Let n = 2^k, enter k (9:13) = ');   
% k  = 11;   

n  = 2^k ; 
n2 = n * 2;

%% ... generate input data for investigating the data and the DFT 

fprintf('\n   get input signal at %d points ...', n2 );
x2 = linspace(-1,1,n2)' ;
y2 = Runge(x2);

%% ... make discrte Fourier transform : agonostic to the input data 

%% ... plain DFT 

fprintf('\n   make and time plain discrete Fourier transform (DFT) ... '); 

tic 
Fn2   = fft( eye(n2 ));
y2hat = Fn2 * y2; 
timeDFT(1) = toc;

fprintf('\n   show the signal profiles: spatial and spectral ... ')

y2hat_centered = fftshift(y2hat);
figure 
subplot(2,1,1)
plot( x2, y2,'b'); 
xlabel('spatial/temporal') 
ylabel('y')
title('signal: spacial profile') 
subplot(2,1,2)
plot( -n:n-1, real(y2hat_centered), 'r') ; 
xlabel('frequency')
ylabel('yhat')
title('signal: spectral profile')


%%  ... set up the sparse transform factors 
%       even-odd permute, decouple, butterfly merge 

fprintf('\n\n   accelerate DFT by one decoupling step ... '); 



% ... decoupled transforms, in parallel 

tic 
dtwid  = Fn2( 1:n, 2) ;              % get the twiddle vector 
Fn     = fft( eye(n)  );
dtwid  = Fn2( 1:n, 2) ;   

yhat_e = Fn * y2( 1:2:n2 );
yhat_o = Fn * y2( 2:2:n2 ); 

% ... butterfly : scaling and Har transform 

yhat_o  = dtwid .* yhat_o ;          % twiddling  
z2hat   = [ yhat_e + yhat_o ; ...    % Har transform 
            yhat_e - yhat_o ];

timeDFT(2) = toc;


%%  ... evaluating accuracy and efficiency 


yzhat_diff = norm( y2hat - z2hat, 'inf');
fprintf('\n   max-err = %.2g', yzhat_diff ) ;
fprintf('\n   wall-clock time [%.2g, %.2g] ', timeDFT(:) );



fprintf('\n\n   %s ended \n\n', mfilename );
%% 

return 

%% Programmer 
% 
%  Xiaobai Sun 
%  Feb. 2024 
% 