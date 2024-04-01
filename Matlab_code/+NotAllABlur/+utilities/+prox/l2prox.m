function [ sol ] = l2prox( y, b, gamma )
sol = max(1 - gamma ./ norm(y - b), 0) .* (y - b);
end
