% Generates the data matrix for the bifurcation diagram
function M = matrix_generator(x0, r_values, steps_trans, steps_asymp)
    % ... initialize the data matrix for bifurcation diagram 
    M = zeros( steps_asymp, length(r_values) );

    %% ... take recurrence steps at earch r value 
    for i = 1:length(r_values)
        r = r_values(i);
        x = x0;                   
        for j = 1:steps_trans   % without recording 
            x = r * x * (1 - x);
        end 
    
        for j = 1:steps_asymp      % with recording 
            x = r * x * (1-x); 
            M(j, i) = x;
        end
    end
end