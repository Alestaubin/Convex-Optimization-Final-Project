function [ sol ] = l2Prox( y1, t, b )

sol = sign(y1 - b) * max(abs(y1(:) - b) - t, 0);

end