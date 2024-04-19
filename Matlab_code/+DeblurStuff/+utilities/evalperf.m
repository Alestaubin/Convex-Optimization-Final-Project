function [ error, term ] = evalperf(x, x0, error, obj)
% EVALPERF Evaluate the performance of an algorithm.
% 
%
%   Input parameters :
%       x       : Input signal
%       x0      : Baseline
%       error   : Array of errors
%       obj     : String of the objective function used
%   Output parameters :
%       error   : Array of errors
%       term    : Terminate indicator. Returns 1 if terminate
%
%
% Evaluates the performance through an objective function by
% comparing it with a moving average after a burn in phase.
%
% `term` will be set to 1 to indicate the termination of the algorithm.
% This is the case if \| x^k - x0 \|_2^2 is greater than the moving
% average, where k is the iteration.
%
% `obj` is either set to be:
%   - "mse" : 1/N * \| x - x0 \|_2^2
%   - "mae"  : 1/N * \| x - x0 \|_1
%
%
    if ~exist('obj', 'var')
      obj = "mse";
    end

    if obj == "mse"
        e = norm(x - x0)^2 ;
    elseif obj == "mae"
        e = norm(x - x0, 1) ;
    else
        error('Unsupported objective function %s', obj);
    end

    e0 = mean(error);
    
    % Determine if we terminate
    if e > e0
        term = 1;
    else
        term = 0;
    end

    % Updates the moving average array
    error = [error(2:size(error, 2)), e];

end







