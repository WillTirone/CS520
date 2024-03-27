% demo_image_blurring.m 
% 
% demo objectives: 
% -- 2D convolution, non-separable 
% -- convolution with small kernel support
% 
% see DEMO_ITERATIVE_DEBLURRING 
% 

clear all
close all

fprintf('\n\n   %s began ...\n',  mfilename );

Igray = imread('peppers.png');
Igray = rgb2gray( Igray ); 
Igray = double( Igray );

figure 
imagesc( Igray ); 
colormap('gray') ; 
title('Original Image');


%%  ... destortion operator and process 

wsize = 3; 
test_cases = {'strong', ... 
              'weak', ... 
              'deficit', ... 
              'laplacian', ...
              'gaussian'} ;

for j = 1: length(test_cases) 
    fprintf('\n   case %d for %s diagonal dominance', j, test_cases{j} ); 
end

idex      = input('\n\n   select an index to a test case = ') ; 
dominance = test_cases{idex};

switch dominance
    case 'strong' 
        beta = 0.5/wsize^2; 
        imax = 10; 
        hk = -ones(wsize,wsize) * beta;      % constant off-diagonal
        hk(2,2) = 1;                         % diagonal element

    case 'weak'
        beta = 1/wsize^2; 
        imax = 60; 
        hk = -ones(wsize,wsize) * beta;      % constant off-diagonal
        hk(2,2) = 1;                         % diagonal element

    case 'deficit'    % diagonal < off-diagonal 
        beta = 1/wsize^(1.7); 
        imax = 30; 
        hk = -ones(wsize,wsize) * beta;      % constant off-diagonal
        hk(2,2) = 1;                         % diagonal element

        % delta-differences decreases, but the errors increase 

    case 'laplacian'   % equal, except at the boundary 
        hk = [ 0, -1, 0; -1, 4, -1; 0, -1, 0]; 
        imax = 150000;  % convergent, but very slow

    case 'gaussian' 
        hk = fspecial('gaussian', 3, 0.56 ); 
        imax = 80; 

    otherwise 
        error('unsupported test case');
end

%%  ... model a mixing distoration with a convolution kernel 

figure 
imagesc( hk )
axis image 
% colormap( "gray" ) 
colorbar 
t_msg = sprintf('Filter : window size %d', size(hk,1)  ) ; 
title( t_msg ) ; 

%%  ... simulate the convolutional mixing process  

Igray  = double( Igray ); 
eItrue = norm( Igray, 'fro'); 

I_blurred = conv2( Igray, hk, 'same') ;  
etai = norm(I_blurred - Igray, 'fro')/ eItrue; 

figure
imagesc( I_blurred ) 
colormap( 'gray' );
t_msg = sprintf('a distored image with discrepancy %.2e', etai );
title( t_msg ); 

return 

%% slow version for demo the detailed operations 

Xf   =  conv_step( Igray, hk );
etai = norm( Xf - Igray, 'fro')/ eItrue; 

figure
imagesc( Xf ) 
colormap( 'gray' );
t_msg = sprintf('a distored image with discrepancy %.2e', etai );
title( t_msg ); 

fprintf('\n\n    %s ended \n\n', mfilename );

return 

%%
%% Xiaobai Sun 
%% Duke CS
%% 