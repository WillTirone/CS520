% function [outputArg1,outputArg2] = image_blurring 
% 
%   imfilter
%   fspecial 
% 

clear all
close all

Irgb = imread('peppers.png');

figure 
imshow( Irgb ); 
title('Original Image');



%% ... set up a filter bank 

kernel_bank = {'average', 'disk', 'gaussian', 'laplacian', 'log', 'prewitt', 'sobel'}; 
for k =1 : length( kernel_bank )
  fprintf('\n   %d : %s ', k, kernel_bank{k} ) ; 
end

k = input('\n   specify the index to a kernel = ');

kernel_type = kernel_bank{k};
wsize = 11;

switch kernel_type  
    case 'average'
     hk = fspecial('average', wsize ); 
    case 'disk' 
     radius = floor( wsize/2 );
     hk = fspecial('disk', radius) ; 
    case 'gaussian' 
     sigma = input('   enter gauss scale parameter sigma = ' );
     hk = fspecial('gaussian', wsize, sigma) ; % see imgaussfilt(er) 
    case 'laplacian' 
     alpha = input('   enter laplacian shape parameter alpha = ' );
     hk = fspecial('laplacian',alpha);  % 3x3 size 
    case 'log'  % Laplacian of Gaussian 
     sigma = input('   enter LoG scale parameter sigma = ' );
     hk = fspecial('log', wsize, sigma); 
    case 'motion' 
     len   = input('   enter motion length = ' ); 
     theta = input('   enter motion angle = ' ); 
     hk = fspecial('motion',len, theta) ; 
    case 'prewitt' 
     transpose_not = input('   horizontal [1] or vertical [0] = ' ); 
     hk = fspecial('prewitt'); 
     if ~transpose_not 
         hk = hk;
     end
    case 'sobel' 
     transpose_not = input('   horizontal [1] or vertical [0] = ' ); 
     hk = fspecial('sobel'); 
     if ~transpose_not 
         hk = hk;
     end
    otherwise error('unsupported filter '); 
end

figure 
imagesc( hk )
axis image 
colormap( bone )
title( [ 'filter kernel:  ', kernel_type ]  )


Irgb_blurred = imfilter( Irgb, hk ); 
figure
imagesc( Irgb_blurred ) 
title('a blurred image')


return 
