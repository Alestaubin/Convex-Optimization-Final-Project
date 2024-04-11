function [ error, term ] = evalperf(x, x0, error)
% EVALPERF Evaluate the performance of an algorithm.
% 
%
%   Input parameters :
%       x       : Input signal
%       x0      : Baseline
%       error   : Array of errors
%   Output parameters :
%       error   : Array of errors
%       term    : Terminate indicator. Returns 1 if terminate
%
%
% Evaluates the performance through \| x - x0 \|_2^2 by
% comparing it with a moving average after a burn in phase.
%
% `term` will be set to 1 to indicate the termination of the algorithm.
% This is the case if \| x^k - x0 \|_2^2 is greater than the moving
% average, where k is the iteration.
%
%

    e = norm(x - x0)^2;
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