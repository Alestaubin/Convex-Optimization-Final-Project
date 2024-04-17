% grid searching for all the algorithms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize default parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = imread('+DeblurStuff/+image_files/cameraman.jpg');
I = rgb2gray(I);

% Resize so each pixel is in between 0 and 1
I = double(I(:, :, 1));
mn = min(I(:));
I = I - mn;
mx = max(I(:));
I = I/mx;

% default i params
i.verbose = 0;
i.malength = 32;
i.maxiter = 200;
i.gammal1 = 0.1;
i.gammal2 = 0.02;
i.tprimaldr = 2;
i.rhoprimaldr = 1.4;
i.tprimaldualdr = 0.8;
i.rhoprimaldualdr = 0.1;
i.tadmm = 2.2;
i.rhoadmm = 1.5;
i.scp = 0.2; 
i.tcp = 0.2;

kernelsize = 10;
% Blurring
%[kernel,b] = DeblurStuff.image_handling.GaussianBlur(I,kernelsize,2);
[kernel, b] = DeblurStuff.image_handling.MotionBlur(I,kernelsize,0);

% Additive noise
b = DeblurStuff.image_handling.SaltnPepper(b, 0.01);


% DRP grid_searching
array_gamma = [0.025, 0.05, 0.075, 0.1, 0.125, 0.15];
array_rho = [0.1, 0.5, 1, 1.5];
array_t = [0.1, 0.5, 1, 1.5];


% Run grid search
for j = array_rho
    i.rhoprimaldr = j;
    for k = array_t
        i.tprimaldr = k;

        % Grid search for l1
        [max_param, error_array] = DeblurStuff.utilities.grid_search('douglasrachfordprimal', i, 'gammal1', array_gamma, b, kernel, 'l1');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible', 'off');

        % plot, title and save graph
        plot(array_gamma, error_array);
        title(sprintf('L1 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/DRP_L1_Error_rho%.2f_t%.2f.png', j, k));

        % Grid search for l2
        [max_param, error_array] = DeblurStuff.utilities.grid_search('douglasrachfordprimal', i, 'gammal2', array_gamma, b, kernel, 'l2');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible', 'off');
        plot(array_gamma, error_array);
        title(sprintf('L2 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/DRP_L2_Error_rho%.2f_t%.2f.png', j, k));

    end
end

% Run grid search
for j = array_rho
    i.rhoprimaldualdr = j;
    for k = array_t
        i.tprimaldualdr = k;

        % Grid search for l1
        [max_param, error_array] = DeblurStuff.utilities.grid_search('douglasrachfordprimaldual', i, 'gammal1', array_gamma, b, kernel, 'l1');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible', 'off');

        % plot, title and save graph
        plot(array_gamma, error_array);
        title(sprintf('L1 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/DRPD_L1_Error_rho%.2f_t%.2f.png', j, k));

        % Grid search for l2
        [max_param, error_array] = DeblurStuff.utilities.grid_search('douglasrachfordprimaldual', i, 'gammal2', array_gamma, b, kernel, 'l2');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible', 'off');
        plot(array_gamma, error_array);
        title(sprintf('L2 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/DRPD_L2_Error_rho%.2f_t%.2f.png', j, k));

    end
end


% Run grid search
for j = array_rho
    i.rhoadmm = j;
    for k = array_t
        i.tadmm = k;

        % Grid search for l1
        [max_param, error_array] = DeblurStuff.utilities.grid_search('admm', i, 'gammal1', array_gamma, b, kernel, 'l1');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible', 'off');

        % plot, title and save graph
        plot(array_gamma, error_array);
        title(sprintf('L1 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/ADMM_L1_Error_rho%.2f_t%.2f.png', j, k));

        % Grid search for l2
        [max_param, error_array] = DeblurStuff.utilities.grid_search('admm', i, 'gammal2', array_gamma, b, kernel, 'l2');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible', 'off');
        plot(array_gamma, error_array);
        title(sprintf('L2 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/ADMM_L2_Error_rho%.2f_t%.2f.png', j, k));

    end
end


% Run grid search
for j = array_rho
    i.scp = j 
    for k = array_t
        i.tcp = k;

        % Grid search for l1
        [max_param, error_array] = DeblurStuff.utilities.grid_search('chambollepock', i, 'gammal1', array_gamma, b, kernel, 'l1');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible','off');

        % plot, title and save graph
        plot(array_gamma, error_array);
        title(sprintf('L1 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/CP_L1_Error_rho%.2f_t%.2f.png', j, k));

        % Grid search for l2
        [max_param, error_array] = DeblurStuff.utilities.grid_search('chambollepock', i, 'gammal2', array_gamma, b, kernel, 'l2');
        fprintf(" the best param over the various gamma is %.2f", max_param);
        fig = figure('Visible','off');
        plot(array_gamma, error_array);
        title(sprintf('L2 Error with rho=%.2f, t=%.2f', j, k));
        xlabel('Gamma');
        ylabel('Error');
        grid on;
        saveas(fig, sprintf('+DeblurStuff/+results/CP_L2_Error_rho%.2f_t%.2f.png', j, k));

    end
end