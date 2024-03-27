% demo_comparison_deblurring.m 
% 
% demo objectives: 
% -- convolution and iterative deconvolution (large sparse linear system) 
% -- iterative deconvolution 
% -- image blurring and deblurring 
% 
% dependency: 
% ===========
% convolution setup script 
%               demo_conv_blurring 
% convolution function 
%               conv2_elementary(...)    
%               at the element program level for connection with deconv ops 
% deconvolution functions 
%               Jacob_deconv_steps(...) 
%               Gauss_Seidel_deconv_steps(...) 
%               ** Warning: both functions are written 
%                  at the element level, slow in execution 
%               ** The Jacobi iteration can be accelerated 
%                  via vector/array operation in CONV2; 
%                  the GS iteration would need special 
%                  HW/SW acceleration module  
% 

clear all 
close all

fprintf('\n\n   %s began ...\n',  mfilename );

demo_conv_blurring          %%  forward blurring process 
                            %%  variables include hk, Igray, imax 

%% ... make the convolution 

f = hk; 
Xtrue  = Igray; 
eItrue = norm( Xtrue, 'fro');

Xf   =  conv2_elementary( Xtrue , f );             % convolutional blurring with demo code 
etai = norm( Xf - Xtrue, 'fro')/ eItrue;           % the initial error in Frobenium norm 




%% ... reverse the convolution process 

kmax = ceil( imax/2 );   % to inspect in the half way  

tic 
fprintf('\n   deconvolve with Jacobi iteration in %d steps ... \n', imax );
Xjacobi  = Jacobi_deconv_steps( Xf, f, kmax, zeros(size(Xf))   ) ; 
Xjacobi2 = Jacobi_deconv_steps( Xf, f, kmax, Xjacobi ) ; 
tJX = toc;  

tic 
fprintf('\n   deconvolve with Gauss-Seidel iteration in %d steps ... \n', imax );
Xgauss   = GaussSeidel_deconv_steps( Xf, f, kmax, zeros(size(Xf))  ) ; 
% Xgauss2  = GaussSeidel_deconv_steps( Xf, f, kmax, Xgauss  ) ; 
%            explain the difference from the next
Xgauss2  = GaussSeidel_deconv_steps( Xf, f, 2*kmax, zeros(size(Xf)) ) ; 
tGauss = toc;

tic 
fprintf('\n   deconvolve with Jacobi iteration via CONV2 in %d steps ... \n', imax );
Yjacobi  = Jacobi_deconv_fast( Xf, f, 2*kmax, zeros(size(Xf)) ) ; 
tJY = toc;




%% === display the deconvolved images 

fprintf('\n   diplay deconvolved images with restoration accuracy  ... \n');
figure 
subplot(2,2,1)
imagesc( Xjacobi ); colormap('gray'); 
axis image 
Jetai =  norm( Xtrue - Xjacobi, 'fro')/eItrue ; % relative discrepancy in f-norm 
x_msg = sprintf('err(step %d) = %0.2e', kmax, Jetai ) ; 
title('Jacobi');
xlabel( x_msg )
%
subplot(2,2,2)
imagesc( Xgauss ); colormap('gray'); 
axis image 
Getai =  norm( Xtrue - Xgauss, 'fro')/eItrue ; % relative discrepancy in f-norm 
x_msg = sprintf('err(step %d) = %0.2e', kmax, Getai ) ;
title('Gauss-Seidel');
xlabel( x_msg ) 
%
subplot(2,2,3)
imagesc( Xjacobi2 ); colormap('gray'); 
axis image 
Jetai =  norm( Xtrue - Xjacobi2, 'fro')/eItrue ; % relative discrepancy in f-norm 
x_msg = sprintf('err(step %d) = %0.2e', 2*kmax, Jetai ) ; 
xlabel( x_msg )
%
subplot(2,2,4)
imagesc( Xgauss2); colormap('gray'); 
axis image 
Gtai =  norm( Xtrue - Xgauss2, 'fro')/eItrue ; % relative discrepancy in f-norm 
x_msg = sprintf('err(step %d) = %0.2e', 2*kmax, Getai ) ; 
xlabel( x_msg )

figure 
imagesc(Yjacobi); colormap('gray'); 
axis image 
title('Deconvolusion via Jacobi convolution steps')
Yetai = norm( Xtrue - Yjacobi, 'fro')/eItrue ; % relative discrepancy in f-norm 
x_msg = sprintf('err(step %d) = %0.2e', 2*kmax, Yetai ) ; 
xlabel( x_msg )


%% ... timing comparison 

fprintf('\n   press a key for comparison in execution efficiency ...');
pause() 

msg_prefix = sprintf('\n\n   seconds[GS, Jacobi, Jacobi-fast] '); 
fprintf('%s \n   = [%.2e, %.2e, %.2e] \n', msg_prefix, tGauss, tJX, tJY);  

fprintf('\n\n   %s ended \n\n\n',  mfilename );
return 

%% Programmer 
%%  Xiaobai Sun 
%%  Duke CS 
%%  ask the programmer for permission of any distribution 
%% 