% Returns the prox of \|y-b\|_1
% Note: this function assumes the input parameters are correct.
function x = l1prox(y, b, lambda)
    x = y - sign(y - b)*lambda;
    i =  abs(y-b) <= lambda;
    x(i) = b(i);
%     x = max(b, y - lambda) + min(b, y + lambda) - b;
end
