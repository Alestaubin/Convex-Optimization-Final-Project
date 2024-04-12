function [ x, summary ] = ADMM( ivals, b, i, problem )
% ADMM Alternating Direction Method of Multipliers
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
%%  Initialize the values
    apply = ivals.apply;
    
    u = ivals.u;
    y = ivals.y;
    w = ivals.w;
    z = ivals.z;
    
    t = i.tadmm;
    rho = i.rhoadmm;

%% Set up the proximal operators 
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );
    
    % select the norm (l1 or l2)
    [ prox_phi, gamma ] = DeblurStuff.utilities.problemSelect(problem, b, 1/t, i);
    prox_psi = @(y2) DeblurStuff.utilities.prox.isoprox( y2, gamma/t );
    
    prox_g = @(y) cat(3, ... % to concatenate the matrices in the 3rd dimension
        prox_phi(y(:,:,1)), ... % pass the top matrix of y to l1prox function
        prox_psi(y(:,:,2:3))); % pass the 2 bottom matrices of y to the isoprox function

%% Main loop
    % error array for early stopping
    error = zeros(1, i.malength) + 1000000;
    for iter=1:i.maxiter
        x = apply.invertMatrix(u + apply.ATrans(y) - ...
            t^(-1)*(w + apply.ATrans(z)));

        u = prox_f(rho*x + (1-rho)*u + w/t);

        y = prox_g(rho*apply.A(x) + (1-rho)*y + z/t);

        z = z + t*(apply.A(x) - y);
        
        w = w + t*(x - u);

        % Miscellaneous updates
        [error, term] = DeblurStuff.utilities.evalperf(apply.K(x), b, error);
        summary.iter = iter;
        summary.e = error(i.malength);
        if term == 1
            break
        end
        if i.verbose == 1
            fprintf('Iteration %i : The error is %.3f \n', iter, ...
                error(i.malength));
        end

    end

    x = apply.invertMatrix(u + apply.ATrans(y) - ...
        t^(-1)*(w + apply.ATrans(z)));

end






