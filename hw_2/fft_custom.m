function [Fdiff, HFPD] = fft_custom(k)
    n  = 2^k; 
    n2 = n * 2;

    Fn  = fft(eye(n));
    Fn2 = fft(eye(n2)); 

    peo = [1:2:n2, 2:2:n2];
    Har  = [1, 1; 1, -1]/2;
    H    = kron(Har, eye(n)); 
    D   = [eye(n), zeros(n); zeros(n), conj(diag(Fn2(1:n,2)))]; 

    HFPD = D * H * Fn2(:,peo); % D*H is also known as ButterFly 

    Fdiff = norm(HFPD - kron(eye(2), Fn)); 
    fprintf('\n   the equality holds within error = %g', Fdiff);
end
