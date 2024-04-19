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


% Plotting grid_search results

% Initialize Parameters for testing
array_rho = [0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 1.0, 1.5]; %list of places to search for first parameter
array_t = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]; %list of places to search for second parameter

% DRP grid search w fixed gamma 0.01
error_array_l1 = DeblurStuff.utilities.grid_search('douglasrachfordprimal', i, ivals, array_rho, array_t, b, kernel, 'l1');
error_array_l2 = DeblurStuff.utilities.grid_search('douglasrachfordprimal', i, ivals, array_rho, array_t, b, kernel, 'l2');

% plotting
DeblurStuff.utilities.plot_grid(array_t, error_array_l1, error_array_l2, 'DRP_grid_search.png');

% DRPD grid search w fixed gamma 0.01
error_array_l1 = DeblurStuff.utilities.grid_search('douglasrachfordprimaldual', i, ivals, array_rho, array_t, b, kernel, 'l1');
error_array_l2 = DeblurStuff.utilities.grid_search('douglasrachfordprimaldual', i, ivals, array_rho, array_t, b, kernel, 'l2');

% plotting
DeblurStuff.utilities.plot_grid(array_t, error_array_l1, error_array_l2, 'DRPD_grid_search.png');

% ADMM grid search w fixed gamma 0.01
error_array_l1 = DeblurStuff.utilities.grid_search('admm', i, ivals, array_rho, array_t, b, kernel, 'l1');
error_array_l2 = DeblurStuff.utilities.grid_search('admm', i, ivals, array_rho, array_t, b, kernel, 'l2');

% plotting
DeblurStuff.utilities.plot_grid(array_t, error_array_l1, error_array_l2, 'ADMM_grid_search.png');

% CP grid search w fixed gamma 0.01
error_array_l1 = DeblurStuff.utilities.grid_search('chambollepock', i, ivals, array_rho, array_t, b, kernel, 'l1');
error_array_l2 = DeblurStuff.utilities.grid_search('chambollepock', i, ivals, array_rho, array_t, b, kernel, 'l2');

% plotting
DeblurStuff.utilities.plot_grid(array_t, error_array_l1, error_array_l2, 'CP_grid_search.png');








