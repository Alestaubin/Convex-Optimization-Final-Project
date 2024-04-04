%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Error from the ground truth %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = mse(x_pred, x_ground)
    x = norm(x_pred - x_ground)^2;
end
    