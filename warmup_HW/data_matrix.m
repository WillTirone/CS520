function [mat] = data_matrix(x0, steps_trans, steps_asymp)
    % function to make a data matrix for our bifurcation diagram
    mat = x0 * ones(steps_trans, steps_asymp);
end