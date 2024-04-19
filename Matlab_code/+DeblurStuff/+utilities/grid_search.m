% Grid search Implementation %
function error_matrix = grid_search(algorithm, i, ivals, array_rho, array_t, b, kernel, problem)
%   GRID_SEARCH We perform grid search keeping one parameter fixed
%   
%   Input Parameters:
%       algorithm       : which of the algorithm
%       i               : all the other parameters being fixed
%       array_t         : array for t 
%       array_rho       : array for rho, or scp
%       b               : Blurred image
%       problem         : l1 or l2, for the norm type
%   Output Parameters:
%       error_matrix    : performance of the different values of the parameter being tested
%
% To elaborate, this function returns a 2D matrix which contains final
% objective values of each of the combinations of the step size t and the
% relaxation rho (or s and t for Chambolle-Pock).
%
%
    % Initialize default parameters
    I = imread('+DeblurStuff/+image_files/cameraman.jpg');
    I = rgb2gray(I);
    
    % Resize so each pixel is in between 0 and 1
    I = double(I(:, :, 1));
    mn = min(I(:));
    I = I - mn;
    mx = max(I(:));
    I = I/mx;

    % initialize params
    kernelsize = 10;
    % Blurring
    %[kernel,b] = DeblurStuff.image_handling.GaussianBlur(I,kernelsize,2);
    [kernel, b] = DeblurStuff.image_handling.MotionBlur(I,kernelsize,0);
    [numRows, numCols] = size(b);
    x = zeros( numRows, numCols );

    % initialize for algo 
    [ivals, i] = DeblurStuff.init.init_algo(algorithm, i, b, x, kernel );
    
    % Initialize cell arrays to hold error vectors
    error_matrix = cell(length(array_rho));
    % Run grid search 
    for k = 1:length(array_rho)
        i.rhoprimaldr = array_rho(k);
        i.rhoprimaldualdr = array_rho(k);
        i.rhoadmm = array_rho(k);
        i.scp = array_rho(k);

        fprintf('iter: rho - %i \n', k);
    
        % Grid search for l1
        temp_error = zeros(length(array_t), 1);
        for j = 1:length(array_t)
            % Dynamically set the test parameter
            i.tprimaldr = array_t(j);
            i.tprimaldualdr = array_t(j);
            i.tadmm = array_t(j);
            i.tcp = array_t(j);

            
            switch lower(algorithm) % Choose the correct algorithm
                case 'douglasrachfordprimal'
                    [~, summary] = DeblurStuff.algorithms.DRP(ivals, b, i, problem);
                case 'douglasrachfordprimaldual'
                    [~, summary] = DeblurStuff.algorithms.DRPD(ivals, b, i, problem);
                case 'admm'
                    [~, summary] = DeblurStuff.algorithms.ADMM(ivals, b, i, problem);
                case 'chambollepock'
                    [~, summary] = DeblurStuff.algorithms.CP(ivals, b, i, problem);
                otherwise
                    error('Unsupported algorithm %s', algorithm);
            end
            temp_error(j) = summary.e;
        end
        temp_error = temp_error(:).'; % turn into row vector
        error_matrix{k} = temp_error;
    end

    % New code to print each cell of the error matrix
    fprintf('\nResults of the Grid Search for %s:\n', problem); % Heading for clarity
    for k = 1:length(array_rho)
        for j = 1:length(array_t)
            fprintf('Error for %s (rho=%.2f, t=%.2f): %f\n', problem, array_rho(k), array_t(j), error_matrix{k}(j));
        end
    end
end
        
        