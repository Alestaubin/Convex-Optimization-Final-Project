% why is this true? Who knows tbh
function x = l1prox(y, b, lambda)
    x = max(b, y - lambda) + min(b, y + lambda) - b;
end
