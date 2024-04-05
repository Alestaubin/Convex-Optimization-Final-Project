% see (17) in the report for the justification of this formula. 
% max and min functions act element-wise on the vector y
% Note: this function assumes the input parameters are correct.
function boxprox_of_y = boxprox(y)
    boxprox_of_y = max(0, min(y, 1));
end
