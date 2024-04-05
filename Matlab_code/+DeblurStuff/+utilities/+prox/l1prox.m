% Returns the l1 prox of (y-b)
% Note: this function assumes the input parameters are correct.
function x = l1prox(y, b, lambda)
    x = max(b, y - lambda) + min(b, y + lambda) - b;
end
