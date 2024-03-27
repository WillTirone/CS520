% function [outputArg1,outputArg2] = image_deblurring ( Dblurred, Bkernel )
% 
% demo script 
% 

clear all
close all

Irgb = imread('peppers.png');
Irgb = rgb2gray( Irgb ); 

figure 
imshow( Irgb ); 
title('Original Image');

%% ... Gaussin blurring 

wsize = 5;
sigma = 1; 
hk    = fspecial('gaussian', wsize, sigma) ;    % see imgaussfilt(er) 

figure 
imagesc( hk )
axis image 
colormap( "gray" ) 
colorbar 
t_msg = sprintf('Gaussian blurr : window size %d, sigma %0.3g', wsize, sigma ); 
title( t_msg ) ; 

Irgb = double( Irgb );

Irgb_blurred = conv2( Irgb, hk, 'same') ; 

% Irgb_blurred = imfilter( Irgb, hk );    % this requires image tool box 
 
figure
imagesc( Irgb_blurred ) 
title('a blurred image')
colormap( "gray" )

%%  ... destortion 



 hk = -ones(3,3)/9;
 hk(2,2) = 1;                 % diagonally dominant 

figure 
imagesc( hk )
axis image 
colormap( "gray" ) 
colorbar 
t_msg = sprintf('Filter : window size %d', size(hk,1)  ) ; 
title( t_msg ) ; 


Irgb_blurred = conv2( Irgb, hk, 'same') ;  

figure
imagesc( Irgb_blurred ) 
title('a destored image')
colormap( "gray" )


%% ... restoration 

wsize  = size( hk,1 ); 
pc     = (wsize+1)/2; 
dc     = hk(pc,pc); 

Jacobi         = - hk/dc ; 
Jacobi(pc, pc) = 0; 

Xtrue    = Irgb ; 
Brhs     = Irgb_blurred/dc; 


imax = 150  ; 
Xi   = Brhs ; 

figure 
for i = 1:imax  
   
   Bi = conv2( Xi, Jacobi, 'same') + Brhs ; 
   Xi = Bi;

   if i ==1 || mod(i,15) == 0 
     etai =  norm( Xtrue - Xi, 'fro'); 

     t_msg = sprintf('restoration err (step %d) = %0.2e', i, etai ) ; 
     imagesc( Xi ) 
     title( t_msg )
     colormap( 'gray'); 

     pause(2) 
   end 
end

return 
