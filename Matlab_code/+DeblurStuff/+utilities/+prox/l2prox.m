function [ sol ] = l2prox( y, b, lambda )
    sol = (2 + b + y) ./ (2*lambda + 1);
end
