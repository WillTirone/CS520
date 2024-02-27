% resize.m
clear all;
close all;

%% Generating resized images
original = imread('duke.png');
resized_1d = resize_1d(double(original), [900, 900]);
resized_1d = (resized_1d - min(resized_1d(:))) / (max(resized_1d(:)) - min(resized_1d(:)));
resized_2d = resize_2d(double(original) , [800, 800]);
resized_2d = (resized_2d - min(resized_2d(:))) / (max(resized_2d(:)) - min(resized_2d(:)));

%% Plotting 1d resized image
fig1 = figure();
hold on;
subplot(1, 2, 1);
image(original);
title('Original Image')
axis image; 

subplot(1,2,2);
image(resized_1d);
title('Expanded Image')
axis image;

sgtitle('Resizing Using 1D Interpolation')
saveas(fig1, 'resized_1d.png');

%% Plotting 2d resized image
fig2 = figure();
subplot(1, 2, 1);
image(original);
title('Original Image')
axis image; 

subplot(1,2,2);
image(resized_2d);
title('Expanded Image')
axis image;

sgtitle('Resizing Using 2D Interpolation')
saveas(fig2, 'resized_2d.png');

hold off;


