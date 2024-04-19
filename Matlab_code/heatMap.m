% This file is not part of the package. It uses MATLABS heatmap() function
% to plot the heatmaps of combinations of two parameters, t and rho.
%
clc, clearvars;
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
%array_t = [0.5, 0.75, 1.0, 1.5];
%array_rho = [0.5, 0.75, 1.0, 1.5];

[F,S] = ndgrid(array_t, array_rho);

i.gammal1 = 0;

%% DRP l1
fprintf("DRP l1")
[ivals, i] = DeblurStuff.init.init_algo('douglasrachfordprimal', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l1','douglasrachfordprimal',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for douglasrachfordprimal l1');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/DRP_l1.jpg');

%% DRPD l1
fprintf("DRPD l1")
[ivals, i] = DeblurStuff.init.init_algo('douglasrachfordprimaldual', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l1','douglasrachfordprimaldual',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for douglasrachfordprimaldual l1');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/DRPD_l1.jpg');

%% ADMM l1
fprintf("ADMM l1")
[ivals, i] = DeblurStuff.init.init_algo('admm', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l1','admm',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for admm l1');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/ADMM_l1.jpg');

%% CP l1
fprintf("CP l1")
[ivals, i] = DeblurStuff.init.init_algo('chambollepock', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l1','chambollepock',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for chambollepock l1');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/CP_l1.jpg');

%% DRP l2
fprintf("DRP l2")
[ivals, i] = DeblurStuff.init.init_algo('douglasrachfordprimal', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l2','douglasrachfordprimal',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for douglasrachfordprimal l2');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/DRP_l2.jpg');

%% DRPD l2
fprintf("DRPD l2")
[ivals, i] = DeblurStuff.init.init_algo('douglasrachfordprimaldual', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l2','douglasrachfordprimaldual',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for douglasrachfordprimaldual l2');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/DRPD_l2.jpg');

%% ADMM l2
fprintf("ADMM l2")
[ivals, i] = DeblurStuff.init.init_algo('admm', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l2','admm',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for admm l2');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/ADMM_l2.jpg');

%% CP l2
fprintf("CP l2")
[ivals, i] = DeblurStuff.init.init_algo('chambollepock', i, b, x, kernel );

fitresult = arrayfun(@(p1,p2) callAlgo('l2','chambollepock',ivals,i,b,p1,p2), F, S); %run a fitting on every pair fittingfunction(F(J,K), S(J,K))

% Plot heatmap
figure;
heatmap(array_t,array_rho, fitresult);
ylabel('t_i');
xlabel('rho_i');
title('Losses for chambollepock l2');

saveas(gcf,'/Users/alexst-aubin/Desktop/gridSearches/CP_l2.jpg');

%% function
function [error] = callAlgo(problem, algo,ivals, i, b, p1, p2)

    i.gammal1 = 0;

    switch lower(algo) % Choose the correct algorithm
            case 'douglasrachfordprimal'
                i.rhoprimaldr = p1;
                i.tprimaldr = p2;
                [~, summary] = DeblurStuff.algorithms.DRP(ivals,b,i,problem);

            case 'douglasrachfordprimaldual'
                i.rhoprimaldualdr = p1;
                i.tprimaldualdr = p2;
                [~, summary] = DeblurStuff.algorithms.DRPD(ivals,b,i,problem);
                
            case 'admm'
                i.rhoadmm = p1;
                i.tadmm = p2;
                [~, summary] = DeblurStuff.algorithms.ADMM(ivals,b,i,problem);
                
            case 'chambollepock'
                i.scp = p1; 
                i.tcp = p2;
                [~, summary] = DeblurStuff.algorithms.CP(ivals,b,i,problem);
            
    end

    error = summary.e;

end