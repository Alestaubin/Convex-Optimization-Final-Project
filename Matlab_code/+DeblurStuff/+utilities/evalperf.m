
function sol = evalperf(x_pred, x_ground)
    sol = norm(x_pred - x_ground)^2;
end