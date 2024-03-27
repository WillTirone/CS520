% demo_deconv_directcirculant 
% 
% demo objectives 
%    Direct deconvolution methods  
%       deconvolution without DFT (brute-force) 
%       deconvolution via FFT (for both efficiency and preconditioning) 
% 
%    Blurring process 
%    -- convoluted, circulant/non-circulant, narrow/broad support 
%    -- weighted or unweighted (such as the Laplacian weights) 
%    -- separable or non-separable (more or less compressible) 
%    
%    Deblurring methods (deconvolution) 
%    -- If (close to) circulent in any dimension, 
%       use FFT along that dimension not only for efficiency 
%       but also for the feasibility of conditioning for deblurring 
%    -- Otherwise, brute-force direct or iterative 
%                   (or preceded by direct, corrected by iterative) 
%    -- sensitive if ill-conditioned and without preconditioning
% 
%    Measures of reconstruction evaluation against the ground-truth 
%    -- difference 
%    -- similarity 
%    -- KL discrepancy 


close all 
clear all 

fprintf('\n\n   %s began ...\n',  mfilename );

%% ... load an image 

Igray = imread('peppers.png');
Igray = double( rgb2gray( Igray ) ); 

[n1,n2] = size( Igray );  

%% ... create a circulant convolution kernel 

band_cases = {'even-band-narrow', ...
              'even-band-not-narrow', ...
              'odd-band-narrow', ... 
              'odd-band-not-narrow'};

for k = 1 : length(band_cases) 
    fprintf('\n   case %d = %s', k, band_cases{k} );
end
idx = input('\n   enter the index to a demo case = '); 

%% ... create a simulated convolution process 

switch band_cases{idx}     % b = kl + ku + 1 the total band of support 
    case 'even-band-narrow'
        b = 4; 
    case 'odd-band-narrow'            % ill-conditioned 
        b = 3; 
    case 'even-band-not-narrow'
        b = 28;
    case 'odd-band-not-narrow'
        b = 27; 
    otherwise 
        error('unsupported demo case')
end

fprintf('\n   the convolution kernel support: b = %d  ', b );
fprintf('\n   generate and display the blurred image ... ');

%% ... contruction of the circulant convolution operators(without weights) 

[c1, r1, T1] = gen_circulant_convolution( n1, b);

[c2, r2, T2] = gen_circulant_convolution( n2, b);

%% ... blur the 2D image with separable circulant convolutions

B  = T1 * Igray ;       % in dim-1
B  = B * T2;            % in dim-2 

figure 
subplot(2,2,1) 
imagesc(Igray) 
subplot(2,2,3)
imagesc(T1);
xlabel('blurring in dim-1')
subplot(2,2,2) 
imagesc(T2);
xlabel('blurring in dim-2')
subplot(2,2,4) 
imagesc( B ) ; 
xlabel('the blurred image')
axis image 
colormap('gray')


%%  ... deconvoluion via brute force solver : higher complexity 

fprintf('\n\n   press a key for DEconvolution via brute force inversion ... \n')
pause();

Y = deconvolution_2D_direct( B, T1, T2) ;

clear T1 T2 

figure 
imagesc( Y )      
colormap('gray')
axis image 
title('deconvolution by brute force direct solver');


%% ... (circulant) deconvolution via FFT 

fprintf('\n   press a key for DEconvolution via FFT diagonalization ...');
pause();

flag_conditioning = input('\n   conditioning when necessary ? [1 or 0] = '); 
X = deconvolution_2D_viaFFT( B, r1, r2, flag_conditioning) ;

figure 
imagesc( X )      
colormap('gray')
axis image 
title('deconvolution via FFT ');

%% ... comparison in reconstruction accuracy 

fprintf('\n   Post-evaluation against the ground-truth ...');

Ydiff = vector_comparison (Igray, Y); 
Xdiff = vector_comparison (Igray, X); 

 
msg_prefix = sprintf('\n   Reconstruction error:\n    [Yerr(brute-force), Xerr(FFT)]');
msg_suffix = sprintf(' = [%0.2e,  %0.2e]', Ydiff.err, Xdiff.err);
fprintf('%s %s', msg_prefix, msg_suffix); 

msg_prefix = sprintf('\n   Reconstruction similarity:\n    [Ysim, Xsim]');
msg_suffix = sprintf(' = [%0.2e,  %0.2e]', Ydiff.sim, Xdiff.sim );
fprintf('%s %s', msg_prefix, msg_suffix); 

%% 

fprintf('\n\n   %s ended \n\n',  mfilename );

return 

%% 
%% Xiaobai Sun 
%% Duke CS 
%% Last revision: March 2023 
%% 