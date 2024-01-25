% Generates the data matrix for the bifurcation diagram
function M = operation_matrix_generator(x0, r_values, steps_trans, steps_asymp)
    % ... initialize the data matrix for bifurcation diagram 
    M = zeros( steps_asymp, length(r_values) );

    x = ones( 1, length(r_values) ) * x0;
                     
    for j = 1:steps_trans   % without recording 
        x = r_values * x * (1 - x);
    end 
    
    for j = 1:steps_asymp      % with recording 
        x = r_values * x * (1-x); 
        M(j, :) = x;
    end
end