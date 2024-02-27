function resized_image = resize_1d(image, spec)
    % Based on spec, find magnification factors
    [m, n, c] = size(image);
    if length(spec) == 2
        new_m = spec(1);
        new_n = spec(2);
    else
        new_m = m * spec;
        new_n = n * spec;
    end
    
    % Initialize the resized image with zeros
    resized_image = zeros(new_m, new_n, c);
    
    % Convert image to double for interpolation
    image = double(image);
    
    % Loop through each color
    for c = 1:c
        % First, interpolate horizontally across each row for the current channel
        intermediate_image = zeros(m, new_n);
        for i = 1:m
            intermediate_image(i, :) = interp1(0:n-1, image(i, :, c), linspace(0, n-1, new_n), 'linear');
        end
        
        % Then, interpolate vertically down each column for the intermediate result
        for j = 1:new_n
            resized_image(:, j, c) = interp1(0:m-1, intermediate_image(:, j), linspace(0, m-1, new_m), 'linear');
        end
    end
end