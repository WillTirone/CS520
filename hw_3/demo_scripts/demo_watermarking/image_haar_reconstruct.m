function IM  = image_haar_reconstruct( im_harr )
% 
%% Input 
%% ======
%% im_harr: a struct of harr components of a 2D data array (image)  
%% 
%% Output 
%% ======= 
%% IM: a 2D data array, reconstruct from HAAR components 
%% 
%% see also image_haar_decomp(...)

IM = ihaart2( im_harr.LL, im_harr.HL, im_harr.LH, im_harr.HH); 

figure 
imagesc( IM )
axis image 
colormap gray 


end

%% =================
%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
%% 