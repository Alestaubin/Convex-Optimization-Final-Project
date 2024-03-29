function [ sol ] = l1Prox( y1, t, b )

sol = sign(y1 - b) * max(abs(y1(:) - b) - t, 0);

end