%Calculating the conjugate of the prox
function output = conjugate_one(prox, y, t)
    arguments
        prox function_handle
        y (:,:,3) double
        t double
    end

    %Apply Moreau decomposition theorem (as shown in the report).
    output = y - t*prox(y/t);
end