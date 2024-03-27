function X = deconvolution_2D_viaFFT( B, r1, r2, flag_conditioning) 
%
%  X = deconvolution_2D_viaFFT( B, r1, r2, flag_conditioning) ;
% 
% Input
% ======
% B:  image blurred by separable 2D circulant convolutions
% r1, r2: the leading rows for the circulant convolutions in dim-1 and
%         dim-2 
% flag_conditioning: boolean 
% 
% Output
% ======= 
% X: image obtained by deconvolution via FFTs 

tau_min = 100*eps;

r1hat      = fft(r1);                    % for the blurring operator in dim-1 
minSigmaT1 = min( abs(r1hat) ); 
maxSigmaT1 = max( abs(r1hat) ); 
kappa1     = maxSigmaT1/minSigmaT1 ;     % condition number of T1 

tau1 = tau_min * maxSigmaT1; 
if minSigmaT1 < tau1 
    fprintf('\n   T1 is near singular'); 
    if flag_conditioning 
      r1small_idx = find( abs(r1hat) < tau1);
      r1hat( r1small_idx ) = tau1;  
    end 
end 

r2hat      = fft(r2);                     % for the blurring operator in dim-2 
minSigmaT2 = min( abs(r2hat) ); 
maxSigmaT2 = max( abs(r2hat) ); 
kappa2     = maxSigmaT2/minSigmaT2 ;      % condition number of T2 

tau2 = tau_min * maxSigmaT2;
if minSigmaT2 < tau2 
    fprintf('\n   T2 is near singular'); 
    if flag_conditioning 
     r2small_idx = find( abs(r2hat) < tau2 );
     r2hat( r2small_idx ) = tau2 ; 
    end
end

msg_prefix = sprintf('\n   Blurring-model condition numbers ');
msg_suffix = sprintf('\n    [kappa1, kappa2] = [ %0.2e, %0.2e] \n', kappa1, kappa2) ;
fprintf('%s %s', msg_prefix, msg_suffix);

Bhat = fft(B.').' ;                                   
Bhat = ifft( Bhat ) ;                             
Xhat = diag(1./r1hat) * Bhat * diag(1./r2hat); 

X = fft( Xhat ); 
X = ifft( X.').'; 
X = real( X);

return 

%% programmer 
%  Xiaobai Sun 
%  Duke CS 

