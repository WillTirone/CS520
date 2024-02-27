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
    adaptive_errors(n-n_min+1) = adaptive_spaced(n);
end


%% Plotting errors

n_values = n_min:n_max;

poly_fig = figure; 
hold on;

plot(n_values, equi_errors, 'b-o', 'LineWidth', 2, 'DisplayName', 'Equidistant Errors');
plot(n_values, chebyshev_errors, 'r-s', 'LineWidth', 2, 'DisplayName', 'Chebyshev Errors');
plot(n_values, adaptive_errors, 'g-^', 'LineWidth', 2, 'DisplayName', 'Adaptive Errors');
xlabel('Degree of Polynomial n');
ylabel('Max Error');
title('Polynomial Fitting Errors');
legend('show');

grid on;


equi_fig = figure;
plot(n_values, equi_errors, 'b-o', 'LineWidth', 2, 'DisplayName', 'Equidistant Errors');
xlabel('Degree of Polynomial n');
ylabel('Max Error');
title('Equi-spaced Errors');

cheby_fig = figure;
plot(n_values, chebyshev_errors, 'r-s', 'LineWidth', 2, 'DisplayName', 'Chebyshev Errors');
xlabel('Degree of Polynomial n');
ylabel('Max Error');
title('Chebyshev Errors');

adapt_fig = figure;
plot(n_values, adaptive_errors, 'g-^', 'LineWidth', 2, 'DisplayName', 'Adaptive Errors');
xlabel('Degree of Polynomial n');
ylabel('Max Error');
title('Adaptive Errors');

saveas(poly_fig, 'polynomial_fitting.png');
saveas(equi_fig, 'equispaced_fitting.png');
saveas(cheby_fig, 'chebyshev_fitting.png');
saveas(adapt_fig, 'adaptive_fitting.png');

hold off;



%%
fprintf('\n\n   %s ended \n\n', mfilename);


return 
