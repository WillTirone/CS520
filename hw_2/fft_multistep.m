% code assistance from ChatGPT
function [HFPD, Fdiff] = fft_multistep(k, steps)
    n  = 2^k; 
    n2 = n * 2;

    Fn  = eye(n);
    Fn2 = eye(n2);

    % Perform multiple FFT steps
    for i = 1:steps
        Fn = fft(Fn);
        Fn2 = fft(Fn2);
    end

    peo = [1:2:n2, 2:2:n2];
    Har  = [1, 1; 1, -1]/2;
    H    = kron(Har, eye(n)); 
    D   = [eye(n), zeros(n); zeros(n), conj(diag(Fn2(1:n,2)))]; 

    HFPD = D * H * Fn2(:,peo); % D*H is also known as Butterfly 

    Fdiff = norm(HFPD - kron(eye(2), Fn)); 
    fprintf('\n   the equality holds within error = %g', Fdiff);
end
