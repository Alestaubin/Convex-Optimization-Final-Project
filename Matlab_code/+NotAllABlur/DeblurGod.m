% Function to handle the user inputs and call the required algorithm
function x = DeblurGod(problem, algorithm, x_init, kernel, b, i)
    % Validate inputs
    validateInputs(problem, algorithm, x_init, kernel, b, i);
    
    % Call the appropriate algorithm
    switch lower(algorithm)
        case 'douglasrachfordprimal'
            x = algorithms.DRP(problem, x_init, kernel, b, i);
        case 'douglasrachfordprimaldual'
            x = algorithms.DRPD(problem, x_init, kernel, b, i);
        case 'admm'
            x = algorithms.ADMM(problem, x_init, kernel, b, i);
        case 'chambollepock'
            x = algorithms.CP(problem, x_init, kernel, b, i);
        otherwise
            error('Invalid algorithm specified.');
    end
end

function validateInputs(problem, algorithm, x_init, kernel, b, i)
    % Validate 'problem' input
    if ~(strcmpi(problem, 'l1') || strcmpi(problem, 'l2'))
        error('Invalid problem specified. Must be ''l1'' or ''l2''.');
    end
    
    % Validate 'algorithm' input
    valid_algorithms = {'douglasrachfordprimal', 'douglasrachfordprimaldual', 'admm', 'chambollepock'};
    if ~any(strcmpi(algorithm, valid_algorithms))
        error('Invalid algorithm specified.');
    end

    % Validate the 'i' input, and add default fields if necessary
end
