% resize_2d_color.m
function resized_image = resize_2d_color(image, spec)
    [m, n, c] = size(image);
    
    % Based on spec, find magnification factors
    if length(spec) == 2
        new_m = spec(1);
        new_n = spec(2);
    else
        new_m = round(m * spec);
        new_n = round(n * spec);
    end
    
    % Initialize the resized image array
    resized_image = zeros(new_m, new_n, c);
    
    % Perform 2d interpolation for each color 
    for i = 1:c
        [X, Y] = meshgrid(linspace(0, n-1, new_n), linspace(0, m-1, new_m));
        resized_image(:,:,i) = interp2(0:n-1, 0:m-1, double(image(:,:,i)), X, Y, 'linear');
    end
end