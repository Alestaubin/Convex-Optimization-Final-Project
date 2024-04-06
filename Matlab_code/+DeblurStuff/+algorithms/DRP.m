
function [ x, summary ] = DRP( ivals, b, i, problem )
arguments
    ivals 
    b 
    i 
    problem 
end
%% Initialize the values
    z1 = ivals.z1;
    z2 = ivals.z2;
    
    t = i.tprimaldr;
    rho = i.rhoprimaldr;

    apply = ivals.apply;

    % select the norm (l1 or l2)
    [ prox_phi, gamma ] = DeblurStuff.utilities.problemSelect(problem, b, t, i);
    
 %% Set up the proximal operators 
    % (the same notation as in the report is used).
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );

    prox_psi = @(y2) DeblurStuff.utilities.prox.isoprox(y2, gamma * t);

    prox_g = @(y) cat(3, ... % to concatenate the matrices in the 3rd dimension
        prox_phi(y(:,:,1)), ... % pass the top matrix of y to l1prox function
        prox_psi(y(:,:,2:3))); % pass the 2 bottom matrices of y to the isoprox function

%% Main loop
    for j=1:i.maxiter
        % Resolvent of A
        % x is an n x m matrix 
        x = prox_f( z1 );

        % y is 3 x n x m
        y = prox_g( z2 );
        
        u = apply.invertMatrix(2*x - z1 + apply.ATrans(2*y - z2));
        
        % v <-- A*u
        v = apply.A(u);
        
        % Update
        z1 = z1 + rho*(u - x);
        z2 = z2 + rho*(v - y);
        
        if i.verbose == 1
            s = DeblurStuff.utilities.evalperf(x,b);
            fprintf('Iter %.2i and the mse is %.3f \n', j, s);
        end
    
    end

    x = prox_f( z1 );
    summary = "Algorithm Ended";

end