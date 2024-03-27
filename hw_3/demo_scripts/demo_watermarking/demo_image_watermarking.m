%% SCRIPT: demo_Image_Watermarking
%% 
%% Objective: use image data to show  
%%   data decomposition by prescribed code vectors (HAAR wavelets in the demo)  
%%   data attenuation/filtering/altering in the coefficients/parameters 
%%   data reconstruction/generation 
%% 
%% Callee functions 
%% image_haar_decomp       (using HAAR tranform) 
%% image_haar_reconstruct  (using inverse HAAR transform) 

close all 
clear all

%% =================================================================


fprintf('\n   %s began ==> ', mfilename ); 


%% ... no change 

haar_level   = 3; 
m = 2048;      % for resizing, analysing and aligning the images 
n = 2048;

fprintf('load two images, make HAAR analysis of each ... '); 

%% ... load an image  
im_name = 'mandrill';
file_ext = 'jpg'; 

IM = imread('mandrill.jpg');
save('mandrill_c.jpg','IM');

IM_haar = image_HAAR_decomp( im_name, file_ext, m, n, haar_level );

%% ... load another image  

ih_name = 'honeybadger'; 
IH_haar = image_HAAR_decomp( ih_name, file_ext, m, n, haar_level );

fprintf('\n\n   press any key for image watermarking '); 
pause();
close all 

%% ... insert a watermark at the prescribed level : private parameters 

tau_marker  = 1e-3 ;  


% ... watermark operations: decompose, alternation in LL channel, construct
% 
IMw_haar    = IM_haar; 
IMw_haar.LL = IM_haar.LL + tau_marker * IH_haar.LL; 
IMw         = image_haar_reconstruct ( IMw_haar ) ; 
title('Image watermarked '); 

%% ... do a marker revealing test before fixed point format truncation

test_flag = 0 ;
if test_flag 
  IM_marker = (IMw_haar.LL - IM_haar.LL)/tau_marker; 
  figure 
  % imshow( IM_marker  )  % with low bitdepth 
  imagesc( IM_marker ) 
  axis square 
  colormap gray
  title('watermarker revealing with high bitdepth')
end 
%% -----------------------------------------------------------------

% ... watermarking the second image with the first as the marker 

fprintf('\n\n   press any key to watermark the other image \n'); 
pause() 

tau_H_marker = 2*1e-2 ;  
IHw_haar     = IH_haar; 
IHw_haar.LL  = IH_haar.LL + tau_H_marker * IM_haar.LL; 
IHw          = image_haar_reconstruct ( IHw_haar ) ; 
title('Image watermarked '); 

%% ... save watermarked image for distribution 

fprintf('\n   Watermarked images saved with no compression for distribution ... ');

imwrite( IMw, 'mandrill-watermarked.tiff', 'tiff', 'Compression', 'none' ); 

imwrite( IHw, 'honeybadger-watermarked.tiff', 'tiff', 'Compression','none' ); 


%%  
fprintf('\n\n   %s end <== \n\n ', mfilename ); 

return 

%% data source: 
%%  >> imfinfo('mandrill.jpg') 
%%  Filename: '/auto/pkg/matlab-2022b/examples/wavelet/data/mandrill.jpg' 
%%  >> imfinfo('honeybadger.jpg') 
%%  Filename: '/auto/pkg/matlab-2022b/examples/wavelet/data/honeybadger.jpg' 
%%  data copied for class use on Feb.2. 2023 
%%  data source suggested by Dimitris Floros 
%% 

 
%% ============================
%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
%% Jan. 31, 2023 
%% For Num. Data Anal. class 
%% ============================