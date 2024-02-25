% plot_errors.m

close all
clear all

fprintf('\n\n   %s began \n', mfilename);

n_min = 5;
n_max = 49;


%% Calculating max errors
equi_errors = zeros(1, n_max - n_min + 1);
chebyshev_errors = zeros(1, n_max - n_min + 1);
adaptive_errors = zeros(1, n_max - n_min + 1);

for n = n_min: n_max
    equi_errors(n-n_min+1) = equi_spaced(n);
    chebyshev_errors(n-n_min+1) = chebyshev_spaced(n);
    % adaptive_errors(n-n_min+1) = adaptive(n);
end


%% Plotting errors

n_values = n_min:n_max;

figure; 
hold on;

plot(n_values, equi_errors, 'b-o', 'LineWidth', 2, 'DisplayName', 'Equidistant Errors');

plot(n_values, chebyshev_errors, 'r-s', 'LineWidth', 2, 'DisplayName', 'Chebyshev Errors');

xlabel('Degree of Polynomial n');
ylabel('Error');
title('Polynomial Fitting Errors');
legend('show');

grid on;

hold off;


%%
fprintf('\n\n   %s ended \n\n', mfilename);


return 
