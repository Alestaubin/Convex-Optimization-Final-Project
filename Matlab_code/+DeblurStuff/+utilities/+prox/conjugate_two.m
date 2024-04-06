%Calculating the conjugate of the prox
function output = conjugate_two(prox, y, t)
    arguments
        prox function_handle
        y (:,:,3) double
        t double
    end

    %Apply Moreau decomposition theorem (as shown in the report).
    %We have two inputs as we use it on the isonorm.
    output = y - t*prox(y/t, 1/t);
end

