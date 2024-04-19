
%%%%%%%%%%%%%
%   blur    %
%%%%%%%%%%%%%

I = imread('+DeblurStuff/+image_files/cameraman.jpg');
I = rgb2gray(I);

% Resize so each pixel is in between 0 and 1
I = double(I(:, :, 1));
mn = min(I(:));
I = I - mn;
mx = max(I(:));
I = I/mx;

kernelsize = 10;
% Blurring
%[kernel,b] = DeblurStuff.image_handling.GaussianBlur(I,kernelsize,2);
[kernel, b] = DeblurStuff.image_handling.MotionBlur(I,kernelsize,0);


[numRows, numCols] = size(b);
x = zeros( numRows, numCols );


%%%%%%%%%%%%%
%   grid    %
%%%%%%%%%%%%%

array_rho = [0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 1.0, 1.5]; %list of places to search for first parameter
array_t = [0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 1.0, 1.5]; %list of places to search for second parameter

[F,S] = ndgrid(array_t, array_rho);

i.gammal1 = 0.01;

[ivals, i] = DeblurStuff.init.init_algo('douglasrachfordprimal', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('douglasrachfordprimal',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t, array_rho, fitresult);
xlabel('t_i');
ylabel('rho_i');
title('Losses for douglasrachfordprimal l1');

%saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/DRP_l1.jpg');

function [error] = callAlgo(algo,ivals, i, b, p1, p2)

    i.gammal1 = 0.01; 
    i.rhoprimaldr = p1;
    i.tprimaldr = p2;
    
    [~, summary] = DeblurStuff.algorithms.DRP(ivals,b,i,'l1');

    error = summary.e;
end