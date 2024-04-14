% Grid search Implementation %
function array_y = grid_search(algorithm, i, test_param, array_of_params, b, kernel, problem)
%   We perform grid search keeping one parameter fixed
%   
%   Input Parameters:
%       algorithm       : which of the algorithm
%       i               : all the other parameters being fixed
%       test_parameter  : which parameter is fixed
%       b               : Blurred image
%       problem         : l1 or l2, for the norm type
%   Output Parameters:
%       array_y         : performance of the different values of the parameter being tested
%
    array_y = zeros(1, length(array_of_params)); % Initialize array of errors
    ivals = init_algo(algorithm, i, b, kernel); % Initialize algorithm values
    
    for j = 1:length(array_of_params)
        i.(test_param) = array_of_params(j); % Dynamically set the test parameter
        
        switch lower(algorithm) % Choose the correct algorithm
            case 'douglasrachfordprimal'
                [~, summary] = DeblurStuff.algorithms.DRP(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            case 'douglasrachfordprimaldual'
                [~, summary] = DeblurStuff.algorithms.DRPD(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            case 'admm'
                [~, summary] = DeblurStuff.algorithms.ADMM(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            case 'chambollepock'
                [~, summary] = DeblurStuff.algorithms.CP(ivals, b, i, problem);
                array_y(j) = summary.e;
                
            otherwise
                error('Unsupported algorithm %s', algorithm);
        end
    end
end
        
        