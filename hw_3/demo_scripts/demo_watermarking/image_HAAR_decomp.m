function haar_decom = image_HAAR_decomp( im_name, fmt, m, n, haar_level )
%% 
%%  h = image_HAAR_decomp( im_name, file_ext, m, n, haar_level ) ;
%% 
%% Input 
%% =======
%% Example: 
%%  im_name = 'mandrill';
%%  fmt = 'jpg';
%%  m = 2048; n = 2048; % for resizing 
%%  haar_level = 3;
%% 
%% Output 
%% =======
%% haar_decom.LL, haar.LH,  haar.HL, haar.HH for the haar components 
%%       up to the specified decomposition level  
%% 

fprintf( ['\n\n   load and display an image of ', im_name] ); 
file_name = [im_name,'.', fmt]; 
IM        = imread( file_name );

if length ( size( IM ) ) > 2   % RGB image 
  IM = rgb2gray( IM );
end 

IM = imresize( im2double( IM ), [m, n] );


msg = ['Image of ', im_name]; 

figure 
imagesc( IM )
colormap gray
title( msg )
axis square
% axis off


level = haar_level;  
msg   = sprintf('Haar Analysis at level %d ', level );
fprintf( ['\n   make and display ', msg] );

[LL_im , LH_im ,HL_im ,HH_im ] = haart2( IM, level );

haar_decom.LL = LL_im;
haar_decom.LH = LH_im;
haar_decom.HL = HL_im;
haar_decom.HH = HH_im;

figure 
subplot(2,2,1)
imagesc( LL_im ); axis image 
title( msg ); 
xlabel('LL component')
% 
subplot(2,2,2)
imagesc( LH_im{level} ) ; axis image 
xlabel('LH component')
% 
subplot(2,2,3)
imagesc( HL_im{level} ) ; axis image 
xlabel('HL component')
% 
subplot(2,2,4)
imagesc( HH_im{level} ) ; axis image 
% 
xlabel('HH component')
colormap( "gray" ); 

return 


%% ============================
%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
%% Jan. 31, 2023 
%% For Num. Data Anal. class 
%% ============================