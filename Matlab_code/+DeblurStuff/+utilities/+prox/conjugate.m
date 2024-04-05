function prox_conj = conjugate(prox, y)
arguments
    prox function_handle
    y 
end
prox_conj = @(y) y - prox(y);
end

