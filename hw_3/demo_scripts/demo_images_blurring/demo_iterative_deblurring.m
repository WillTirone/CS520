% demo_iteraative_deblurring.m 
% 
% Demo objectives: 
% -- iterative deconvolution when the convolution is far from circulant 
% -- iterative inversion of a large (and sparse) linear system 
% -- conditions for Jacobi iteration to converge/diverge 
% 
% Blurring operation setup 
%   demo_conv_blurring 
% Iterative deblurring function 
%   Jacobi_deconv_fast 
% 
% use script DEMO_CONV_BLURRING  
% 

clear all 
close all

fprintf('\n\n   %s began ...\n',  mfilename );

fprintf('\n   simulate a blurring process ...');

demo_conv_blurring           %%  forward blurring process 
                             %%  variables: Igray, I_blurred, hk, and imax 

%% ... iterative restoration process 


fprintf('\n   restoration by Jacobi iteration with maxIterSteps = %d ... \n   ', imax );

f = hk;                                    % The blurring/diffusion operator 
Xtrue  = Igray;                     
eItrue = norm( Xtrue, 'fro');              % Euclidean length of Xtrue 

Brhs =  I_blurred;                         % RHS: blurred, Brhs = f( Xtrue )

Xk   = Brhs;                               % Initial guess 

kbatchs = 10;                              % iterate in batches 
ksteps  = ceil( imax/kbatchs );            % per batch 

etaBatch   = zeros( kbatchs,1);
deltaBatch = zeros( kbatchs,1); 

figure         % for annimating the iteration process 

kb = 1; 
for k = 1: ksteps : imax 

  fprintf(' %d ...', k);

  % ... iterate the next ksteps 

  Yk = Jacobi_deconv_fast( Brhs, f, ksteps, Xk ) ; 
  
  etak    = norm( Yk - Xtrue, 'fro')/eItrue; 
  deltak  = norm( Yk - Xk, 'fro')/norm(Xk, 'fro');  
  Xk      = Yk;

  etaBatch(kb)   = etak;
  deltaBatch(kb) = deltak; 
  kb = kb+1;

  % ... display every ksteps 

  imagesc( Xk) ; 
  colormap('gray'); 
  axis image 
    
  t_msg = sprintf('step %d: delta = %.2e, err = %.2e', k, deltak, etak); 
  title( t_msg ); 
  pause(2) 

end

%% 

figure 
semilogy( 1:kbatchs, deltaBatch, 'mx-.', 1:kbatchs, etaBatch, 'b+-.' );
legend('deltaBatch','etaBatch'); 
title('differences at batch boundary steps');

%% 

fprintf('\n\n    %s ended \n\n', mfilename );

return 

%% =========================================================
%% Programmer 
%%  Xiaobai Sun 
%%  Duke CS 
%%  Revision: March 13, 2024 
%%  ask the programmer for permission of any distribution 
%% 

