% define our data matrix function


% Start the timer
tic;

% Parameters
%r_values = linspace(2.4, 4, 1000); % Range of parameter values
r_values = linspace(3.8, 7, 1000); 
iterations = 2000; % Number of iterations for each parameter value
transient = 100; % Number of transient iterations to discard

% Initialize bifurcation diagram
bifurcation_diagram = zeros(iterations - transient, length(r_values));

% Loop over each parameter value
for i = 1:length(r_values)
    r = r_values(i);
    x = 0.5; % Initial condition
    
    % Iterate the quadratic map
    for j = 1:iterations
        x = r * x * (1 - x);
        
        % Store values after transient iterations
        if j > transient
            bifurcation_diagram(j - transient, i) = x;
        end
    end
end

% Stop the timer
elapsed_time = toc;

% Display the elapsed time
fprintf('Elapsed time: %f seconds\n', elapsed_time);

% Plot bifurcation diagram
figure;
plot(r_values, bifurcation_diagram, '.', 'MarkerSize', 1);
title('Bifurcation Diagram of Quadratic Recurrence Map');
xlabel('Parameter (r)');
ylabel('Population');
