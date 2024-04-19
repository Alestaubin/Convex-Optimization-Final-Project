% This file is not part of the package. It simply plots the evolution of
% the objective values for each algorithm, used in the final report. We
% plot the mse loss be default.
%
clc, clearvars;
%%%%%%%%%%%%%
%   blur    %
%%%%%%%%%%%%%

% Import image
I = imread('+DeblurStuff/+image_files/drake.jpg');
try 
    I = rgb2gray(I);
catch
    I = im2gray(I);
end

% Resize so each pixel is in between 0 and 1
I = double(I(:, :, 1));
mn = min(I(:));
I = I - mn;
mx = max(I(:));
I = I/mx;

kernelsize = 10;
% Blurring
[kernel, b] = DeblurStuff.image_handling.MotionBlur(I,kernelsize,0);

% Additive Noise
b = DeblurStuff.image_handling.Poisson(b);


%%%%%%%%%%%%%%
%   plots    %
%%%%%%%%%%%%%%


[numRows, numCols] = size(b);

problem = 'l1';
i = struct;

x = zeros( numRows, numCols );
[ivals, i] = DeblurStuff.init.init_algo( 'douglasrachfordprimal', i, b, x, kernel );
[ ~, summary1 ] = DeblurStuff.algorithms.DRP(ivals, b, i, problem);

x = zeros( numRows, numCols );
[ivals, i] = DeblurStuff.init.init_algo( 'douglasrachfordprimaldual', i, b, x, kernel );
[ ~, summary2 ] = DeblurStuff.algorithms.DRPD(ivals, b, i, problem);

x = zeros( numRows, numCols );
[ivals, i] = DeblurStuff.init.init_algo( 'admm', i, b, x, kernel );
[ ~, summary3 ] = DeblurStuff.algorithms.ADMM(ivals, b, i, problem);

x = zeros( numRows, numCols );
[ivals, i] = DeblurStuff.init.init_algo( 'chambollepock', i, b, x, kernel );
[ ~, summary4 ] = DeblurStuff.algorithms.CP(ivals, b, i, problem);


figure;
plot(1:summary1.iter, summary1.e_arr);
hold on 
plot(1:summary2.iter, summary2.e_arr);
hold on 
plot(1:summary3.iter, summary3.e_arr);
hold on 
plot(1:summary4.iter, summary4.e_arr);
hold off





