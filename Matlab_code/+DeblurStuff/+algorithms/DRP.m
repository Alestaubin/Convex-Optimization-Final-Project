function [ x, summary ] = DRP( ivals, b, i, problem )
% DRP Primal Douglas-Rachford Splitting
% 
%
%   Input parameters :
%       ivals   : Initial values
%       b       : Blurred image
%       i       : Struct of parameters
%       problem : "l1" or "l2" problem
%   Output parameters :
%       x       : Optimized image
%       summary : Structure with convergence results
%
% 
% Solves the optimization problem as described in `DeblurGod`.
%
%
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
    
 %% Set up the proximal operators 
    % (the same notation as in the report is used).
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );

    % select the norm (l1 or l2)
    [prox_phi, gamma] = DeblurStuff.utilities.problemSelect(problem, b, t, i);
    prox_psi = @(y) DeblurStuff.utilities.prox.isoprox(y, t*gamma);

    prox_g = @(y) cat(3, ... % to concatenate the matrices in the 3rd dimension
        prox_phi(y(:,:,1)), ... % pass the top matrix of y to l1prox function
        prox_psi(y(:,:,2:3))); % pass the 2 bottom matrices of y to the isoprox function

%% Main loop
    % error array for early stopping
    error = zeros(1, i.malength) + 1000000;
    for iter=1:i.maxiter
        % Resolvent of A
        x = prox_f( z1 );
        y = prox_g( z2 );
        
        % Resolvent of B
        u = apply.invertMatrix(2*x - z1 + apply.ATrans(2*y - z2));
        v = apply.A(u); % v <-- A*u
        
        % Update
        z1 = z1 + rho*(u - x);
        z2 = z2 + rho*(v - y);
        
        % Miscellaneous updates
        [error, term] = DeblurStuff.utilities.evalperf(apply.K(x), b, error);
        summary.iter = iter;
        summary.e = error(i.malength);
        if term == 1
            break
        end
        if i.verbose == 1
            fprintf('Iteration %i : The error is %.6f \n', iter, ...
                error(i.malength));
        end
    
    end

    x = prox_f( z1 );

end
