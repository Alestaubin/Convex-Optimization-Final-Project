function [ sol ] = boxProx( x, t )
% prox_{t, f} (x) = argmin_{u \in S} \frac{1}{2t} \|x - u\|_2^2
% where S := \{ x : x \in [0, 1] \}

% Creates a copy and transforms into a column vector
sol = x;
sol = sol(:);
% Gets indices out of bounds
g = sol > 1;
l = sol < 0;
% Performs box projection, and reshape to original size
sol(g) = 1;
sol(l) = 0;
sol = reshape(sol, size(x)) * 1/t ;

end