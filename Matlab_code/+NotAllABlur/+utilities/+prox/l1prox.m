function [ l1_prox_of_y ] = l1prox(y,lambda)
    % computes the l1 prox operator of y 
    arguments
        y 
        lambda double
    end
    
    % get dimensions of the matrix y
    dim = size(y);
    %initialize the matrix
    l1_prox_of_y = zeros(dim(1), dim(2));
    
    for i = 1:dim(1)
        for j = 1:dim(2)
            if y(i,j) > lambda 
                l1_prox_of_y(i,j) = y(i,j) - lambda;
            elseif y(i,j) < lambda 
                l1_prox_of_y(i,j) = y(i,j) - lambda;
            else 
                l1_prox_of_y(i,j) = 0;
            end
        end
    end
end

% function [ sol ] = l1Prox( y, b, gamma )
% sol = sign(y - b) .* max(abs(y - b) - gamma, 0);
% end