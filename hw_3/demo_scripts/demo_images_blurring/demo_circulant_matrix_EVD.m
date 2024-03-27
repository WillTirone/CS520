% 
% demo_circulant_matrix_EVD.m 
% 
% the eigenvalue decomposition of a circulant matrix C 
% 
% the eigenvectors are F or Fi 
% C * F  = F * diag( rhat );   rhat = fft(r);  
% C * Fi = Fi * diag( chat );  chat = fft(c); 
% 
% chat = conj( rhat ) when C is real-valued 
% 

close all 
clear all 

fprintf('\n\n   %s began ...\n' , mfilename ) ;

n  = 16; 
kl = 3;
ku = 2; 

c = [ ones(1+kl,1); zeros(n-(kl+ku+1),1) ; ones(ku,1) ];  % leading column
r = [ ones(1+ku,1); zeros(n-(kl+ku+1),1) ; ones(kl,1) ];  % leading row 

rhat = fft(r) ;     % rhat = diag( Fi * C * F ) 

chat = fft(c) ;     % chat = diag( F * C * Fi ) 


%% ... fast reconstruct 

C  = toeplitz(c,r) ;       % explicit formation of the circulant matrix  

Tr = fft( diag(rhat) );
Tr = ifft( Tr.' ).' ;        % use [.'] for non-conjugate transpose 
er = norm(Tr-C,'fro') ; 

Tc = ifft( diag(chat) );
Tc = fft( Tc.' ).' ;         % use [.'] for non-conjugate transpose 
ec = norm(Tc-C,'fro'); 

%% ... display 
figure 
%
subplot(1,2,1) 
imagesc( Tr )
axis image 
title('rhat version')
xlabel(sprintf('reconstruct err = %.2e', er));
%
subplot(1,2,2)
imagesc( Tc )
axis image 
title('chat version')
xlabel(sprintf('chat reconstruct err = %.2e', ec));


%%% ... explicit factorization and slow reconstruct 


Fn   = fft( eye(n) );        % explicit formation of the Fourier transform 


CFi   = C * conj(Fn)/n ;              % column version: diagonalization 
FCFi  = Fn * CFi ; 

diff_chat = norm( chat - diag( FCFi), 'fro' ) ; % chat = F*C*Fi, C*Fi = Fi *chat ;    


CF   = C * Fn;                        % row version: diagonalization        
FiCF = conj(Fn) * CF/n;

diff_rhat = norm( rhat - diag( FiCF), 'fro' ) ; % rhat = Fi * C * F; C*F = F*rhat ; 

fprintf('\n   [diff-rhat, diff-chat] = [%0.2e, %0.02e ] \n\n', diff_rhat, diff_chat) ; 


%% ... display the diagonalzation process 

figure 
spy(C)
title('circulant matrix for circulant convolution')

%%
figure 
subplot(2,2,1)
imagesc ( real( CFi ) ) 
colorbar 
title('chat version')
subplot(2,2,2)
imagesc ( imag( CFi ) )
colorbar 
subplot(2,2,3) 
imagesc( real(FCFi - diag(diag(FCFi)) ));
xlabel('real(off-diag)') 
colorbar 
subplot(2,2,4) 
imagesc( imag(FCFi - diag(diag(FCFi)) )) 
xlabel('imag(off-diagonal)')
colorbar 

%% 
figure 
subplot(2,2,1)
imagesc ( real( CF ) ) 
colorbar 
title('rhat version')
subplot(2,2,2)
imagesc ( imag( CF ) )
colorbar 
subplot(2,2,3) 
imagesc( real(FiCF - diag(diag(FiCF)) ));
xlabel('real(off-diagnal)')
colorbar 
subplot(2,2,4) 
imagesc( imag(FiCF - diag(diag(FiCF)) )) 
xlabel('imag(off-diagonal)') 
colorbar 

fprintf('\n\n   %s ended \n\n' , mfilename ) ;

return 

%%
%% 
%% Xiaobai Sun 
%% 