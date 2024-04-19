% Convex Optimization Project
% Test and run the code in this file.


%%%%%%%%%%%%%%%%%%%%
% Image set up
%%%%%%%%%%%%%%%%%%%%
clearvars, clc;
% Import image
I = imread('+DeblurStuff/+image_files/cameraman.jpg');
I = rgb2gray(I);

% Resize so each pixel is in between 0 and 1
I = double(I(:, :, 1));
mn = min(I(:));
I = I - mn;
mx = max(I(:));
I = I/mx;

% Show image
%figure('Name','image before deblurring')
%imshow(I,[])


%%%%%%%%%%%%%%%%%%%%
% Convolution kernels and noise (at least 2 variations of each)
%%%%%%%%%%%%%%%%%%%%

%%%%% MOVE/REMOVE THIS SECTION 
kernelsize = 10;

% Blurring
%[kernel,b] = DeblurStuff.image_handling.GaussianBlur(I,kernelsize,2);
[kernel, b] = DeblurStuff.image_handling.MotionBlur(I,kernelsize,0);

% Additive noise
b = DeblurStuff.image_handling.SaltnPepper(b, 0.01);

%figure('Name','image after blurring')
%imshow(b,[])


%%%%%%%%%%%%%%%%%%%%
% Algorithm setup
%%%%%%%%%%%%%%%%%%%%
i.verbose = 0;
i.malength = 32;
i.maxiter = 100;
i.gammal1 = 0.1;
i.gammal2 = 0.01;
i.tprimaldr = 2;
i.rhoprimaldr = 1.4;
i.tprimaldualdr = 0.8;
i.rhoprimaldualdr = 0.1;
i.tadmm = 2.2;
i.rhoadmm = 1.5;
i.scp = 0.2; 
i.tcp = 0.2;
[numRows, numCols] = size(b);
x = zeros( numRows, numCols );
% x = DeblurStuff.DeblurGod('l1', 'douglasrachfordprimal', x, kernel, b, i);
x = DeblurStuff.DeblurGod('l2', 'douglasrachfordprimaldual', x, kernel, b, i);
% x = DeblurStuff.DeblurGod('l2', 'admm', x, kernel, b, i);
% x = DeblurStuff.DeblurGod('l1', 'chambollepock', x, kernel, b, i);


figure('Name','image after deblurring')
imshow(x,[])


%%%%%%%%%%%%%%%%%%%%
% Hyperparameter tuning
%%%%%%%%%%%%%%%%%%%%
% @Elliot get this done, yes I shall

% Decent/good parameters:
% PDRS: gammal1 = 0.1, t = 2, rho = 1.5
% ADMM l1: decent ones as PDRS
% ADMM l2: ok baseline - gammal2 = 0.025, t = 2, rho = 1.5
% DRPD l1: (ok)  t = 1.0, rho = 0.1

% SEE OVERLEAF FOR THE COMPLETE LIST
% convolution kernel
% noise
% blurring b
% step size t
% relaxation parameter rho
%

%trying out to learn how to plot

array_x = [1, 2, 3, 4, 5, 6];
array_ys_1 = [2, 4, 5, 6, 7, 9];
array_ys_2 = [1, 3, 4, 7, 8, 9];

figure;
plot(array_x, array_ys_1, '-o'); % '-o' adds markers at data points
hold on; % Keeps the current plot and allows for adding another plot to it
plot(array_x, array_ys_2, '-*');
hold off;
title('Line Plot Comparison');
xlabel('X');
ylabel('Y');
legend('Data Set 1', 'Data Set 2');









