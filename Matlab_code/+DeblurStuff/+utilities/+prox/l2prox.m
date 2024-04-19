% returns the l2 prox of (y-b)
% Note: this function assumes the input parameters are correct.
function [ sol ] = l2prox( y, b, lambda )
    sol = (y + 2*lambda*b) ./ (2*lambda + 1);
end
