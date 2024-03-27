%% SCRIPT: demo_image_watermarker_revealing 
%% 
%% Objective: use image data to show  
%%   data decomposition by prescribed code vectors (HAAR wavelets in the demo)  
%%   data attenuation/filtering/altering in the domain of coefficients/parameters 
%%   data reconstruction/generation 
%% 
%% Callee functions 
%% image_haar_decomp       (using HAAR tranform) 
%% image_haar_reconstruct  (using inverse HAAR transform) 

close all 
clear all

%% =================================================================

fprintf('\n   %s began ==> ', mfilename ); 

%%  ... private watermarker parameters 

haar_level = 3;
tau_marker   = 1e-3;    % must be the same as the insertion parameter 

m = 2048;               % for resizing, analysing, aligning the images 
n = 2048;


%% ... load the authentic image   and a watermarked image 

im_name  = 'mandrill';                   % image file name 
fmt      = 'jpg';                        % data format 

im_name_w = 'mandrill-watermarked';      % image file name 
fmt_w       = 'tiff';                    % data format 

%% ... make HARR analysis on both images 

m = 2048;         % for resizing, analysing and aligning the images 
n = 2048;
                  % load, analysize and display 
IM_haar   = image_HAAR_decomp( im_name,    fmt, m, n, haar_level );
IMw_haar  = image_HAAR_decomp( im_name_w , fmt_w, m, n, haar_level ); 

                  % the difference in the 2D low-low pass filters 
IM_marker  = ( IMw_haar.LL - IM_haar.LL )/tau_marker ; 

figure 
imagesc( IM_marker )
axis image 
colormap bone 
title('The revealed watermarker (noisy due to format truncation)') 


%% ... load another image 

fprintf('\n\n   press a key to exam another pair of images ... '); 
pause() 

close all; 

ih_name  = 'honeybadger';
fmt      = 'jpg'; 

ih_name_w = 'honeybadger-watermarked';
fmt_w       = 'tiff';

IH_haar   = image_HAAR_decomp( ih_name,    fmt,   m, n, haar_level );
IHw_haar  = image_HAAR_decomp( ih_name_w , fmt_w, m, n, haar_level ); 

tau_H_marker   = 2*1e-2 ;  % must be the same as the insertion parameter 
                           % difference in LL coefficients 

IH_marker = ( IHw_haar.LL - IH_haar.LL )/tau_marker ; 

figure 
imagesc( IH_marker )
axis image 
colormap bone 
title('the revealted watermarker (noisy due to format truncation)') 


%% 
fprintf('\n\n   %s end <== \n\n ', mfilename ); 

return 

%% ============================
%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
%% Initial: Jan. 31, 2023 
%% Revision: March 10, 2024 
%% For Num. Data Anal. class 
%% ============================