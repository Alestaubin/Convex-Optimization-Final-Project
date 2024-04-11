function [p, gamma] = problemSelect( problem, b, t, i )
% PROBLEMSELECT Helper function that determines the problem
% 
%
%   Input parameters :
%       problem : "l1" or "l2" problem
%       b       : Blurred image
%       t       : Step size hyperparameter
%       i       : Struct of parameters
%   Output parameters :
%       p       : Function handle of the prox operator of the problem
%       gamma   : Constant for the iso norm
%
%
% Function that facilitates problem selection by creating constants.
%
%
    switch lower(problem)
        case 'l1'
            p =@(y) DeblurStuff.utilities.prox.l1prox( y, b, t );
            gamma = i.gammal1;
        case 'l2'
            p =@(y) DeblurStuff.utilities.prox.l2prox( y, b, t );
            gamma = i.gammal2;
        otherwise
            error('Unknown problem.');
    end
end