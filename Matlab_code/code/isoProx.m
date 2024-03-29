function [ sol ] = isoProx( y2, y3, t )

sol.iso = [y2, y3] - t / (y2.^2 + y3.^2).^(1/2);

end