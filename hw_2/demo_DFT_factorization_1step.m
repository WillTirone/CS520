% demo_DFT_factorization.m 
% 
% Objective: sparse factorization of DFT 
%            compressive representation of DFT 
%            for the case what the size n is a power of 2 
% 
% For a size that is not a power of 2, the factorizations 
% involve nested convolution and factorizations 
% 

clear all 
close all

fprintf('\n\n   %s began ...', mfilename );

k = input('\n   Let n = 2^k, enter k = ');   % k = 4, ..., 9 for instance

n  = 2^k ; 
n2 = n * 2;


%% ... generate and display F(n) and F(2n)

fprintf('\n   generate and display F(%d) and F(%d)', n, n2);

Fn  = fft( eye(n)  );
Fn2 = fft( eye(n2) ); 

%% 
figure 
subplot(2,2,1) 
imagesc( real( Fn ) ); 
axis equal tight 
xlabel( 'real part' ); 
title( sprintf('F(%d)',n)) 
% 
subplot(2,2,2) 
imagesc( imag( Fn ) ); 
axis equal tight 
xlabel( 'imag part'); 
% 
subplot(2,2,3) 
imagesc( real(Fn2) ); 
axis equal tight 
xlabel( 'real part' ); 
title( sprintf('F(%d)',n2)) 
% 
subplot(2,2,4) 
imagesc( imag(Fn2) ); 
axis equal tight 
xlabel( 'imag part'); 

%%  ... make an even-odd permutation 
%            a Har transform 
%            and a twiddle scaling

fprintf('\n   sparse transform F(%d)',  n2); 

peo = [ 1:2:n2, 2:2:n2 ];
Har  = [ 1, 1; 1, -1]/2;
H    = kron( Har, eye(n) ); 
D   = [ eye(n), zeros(n); zeros(n), conj( diag( Fn2(1:n,2) )) ]; 

HFPD = D * H * Fn2(:,peo) ; % D*H is also known as ButterFly 

%% ... confirm the equality 

Fdiff = norm ( HFPD - kron( eye(2), Fn)); 
fprintf('\n   the equality holds within error = %g', Fdiff);


%% 
figure 
subplot(1,2,1) 
imagesc( real( HFPD) ); 
axis equal tight 
xlabel( 'real part' ); 
title(sprintf('F(%d) decoupled to two F(%d) ', n2, n)) ; 
% 
subplot(1,2,2) 
imagesc( imag( HFPD ) ); 
axis equal tight 
xlabel( 'imag part'); 
title( 'via sparse transform' ) ; 

%%

fprintf('\n\n   %s ended \n\n', mfilename );
%% 

return 

%% Programmer 
% 
%  Xiaobai Sun 

% 