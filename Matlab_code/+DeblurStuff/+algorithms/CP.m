function [x_sol, summary] = CP(ivals, b, i, problem)
arguments
    ivals 
    b 
    i 
    problem 
end
 %% Initialize values
    s = i.scp;
    t = i.tcp;
    x = ivals.x;
    y = ivals.y; 
    z = ivals.z;
    apply = ivals.apply;

    % check that      ||   ||2
    %              st*|| A ||   < 1 
    %                 ||   ||2   

    % get appropriate gamma and norm (depending on whether the problem is
    % l1 or l2)
    
    [ prox_phi, gamma ] = DeblurStuff.utilities.problemSelect(problem, b, t, i);
    
 %% Set up the proximal operators 
    % (the same notation as in the report is used).
    prox_psi = @(y2) DeblurStuff.utilities.prox.isoprox(y2, gamma * t);

    prox_g = @(y) cat(3, ... % to concatenate the matrices in the 3rd dimension
        prox_phi(y(:,:,1)), ... % pass the top matrix of y to l1prox function
        prox_psi(y(:,:,2:3))); % pass the 2 bottom matrices of y to the isoprox function

    prox_gstar = @(y) DeblurStuff.utilities.prox.conjugate_one(prox_g, y, t);
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );

 %% Main loop
    for j=0:i.maxiter

        x_prev = x; 

        y = prox_gstar(y + s * apply.A(z));
       
        x = prox_f(x - t * apply.ATrans(y));

        z = 2*x - x_prev;

    end

    x_sol =  x ;
    summary = "Algorithm Ended";

end