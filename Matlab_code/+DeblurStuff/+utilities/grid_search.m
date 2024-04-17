% Grid search Implementation %
function [max_param, array_y] = grid_search(algorithm, i, test_param, array_of_params, b, kernel, problem)
%   We perform grid search keeping one parameter fixed
%   
%   Input Parameters:
%       algorithm       : which of the algorithm
%       i               : all the other parameters being fixed
%       array_of_params : the various values of the test parameter to be
%       tes
%       test_parameter  : which parameter is fixed
%       b               : Blurred image
%       problem         : l1 or l2, for the norm type
%   Output Parameters:
%       array_y         : performance of the different values of the parameter being tested
%
    array_y = zeros(length(array_of_params)); % Initialize array of errors
    [numRows, numCols] = size(b);
    x = zeros( numRows, numCols );

    
    for j = 1:length(array_of_params)
        i.(test_param) = array_of_params(j); % Dynamically set the test parameter
        
        switch lower(algorithm) % Choose the correct algorithm
            case 'douglasrachfordprimal'
                [ivals, i] = DeblurStuff.init.init_algo('douglasrachfordprimal', i, b, x, kernel );
                [~, summary] = DeblurStuff.algorithms.DRP(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            case 'douglasrachfordprimaldual'
                [ivals, i] = DeblurStuff.init.init_algo('douglasrachfordprimaldual', i, b, x, kernel );
                [~, summary] = DeblurStuff.algorithms.DRPD(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            case 'admm'
                [ivals, i] = DeblurStuff.init.init_algo('admm', i, b, x, kernel );
                [~, summary] = DeblurStuff.algorithms.ADMM(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            case 'chambollepock'
                [ivals, i] = DeblurStuff.init.init_algo('chambollepock', i, b, x, kernel );
                [~, summary] = DeblurStuff.algorithms.CP(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            otherwise
                error('Unsupported algorithm %s', algorithm);
        end
    end

    [max_val, max_idx] = max(array_y);
    max_param = array_of_params(max_idx); % return the best parameter over the given search
end
        
        