function IM  = image_haar_composition( im_harr )
% 
%% Input 
%% ======
%% im_harr: a struct of harr components of a 2D data array (image)  
%% 
%% Output 
%% ======= 
%% IM: a 2D data array, reconstruct from HAAR components 

IM = ihaart2( im_harr.LL, im_harr.HL, im_harr.LH, im_harr.HH); 

end

%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
