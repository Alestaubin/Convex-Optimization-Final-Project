function [iso_prox_of_y] = isoprox(y,gamma)
arguments
    y {double}
    gamma double
end
% returns the isotropic proximal operator of y. 

% split y in 2
y2 = y(:, :, 1);
y3 = y(:, :, 2);

% Get size of y2 and y3 
% dim(1) = # of rows, dim 2 = # of cols
dim = size(y2);

% initialize matrix with zeros
iso_prox_of_y = zeros(dim(1), dim(2), 2);

% Iterate through each entry
for i = 1:dim(1)
    for j = 1:dim(2) 
        % get alpha
        if sqrt(y2(i,j)^2 + y3(i,j)^2) > gamma
            alpha = 1 - gamma / (sqrt(y2(i,j)^2 + y3(i,j)^2));
        else 
            alpha = 0;
        end
        % get element-wise isoprox. 
        iso_prox_of_y(i,j, 1) = alpha * y2(i,j);
        iso_prox_of_y(i,j, 2) = alpha * y3(i,j);
    end
end

end

