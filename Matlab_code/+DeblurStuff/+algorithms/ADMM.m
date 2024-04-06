
function [ x, summary ] = ADMM( ivals, b, i, problem )
arguments
    ivals 
    b 
    i 
    problem 
end
%%  Initialize the values
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
    for iter=1:i.maxiter
        x = ivals.apply.invertMatrix(u + ivals.apply.ATrans(y) - ...
            t^(-1)*(w + ivals.apply.ATrans(z)));
        u = prox_f(rho*x + (1-rho)*u + w/t);
        y = prox_g(rho*ivals.apply.A(x) + (1-rho)*y + z/t);
        z = z + t*(ivals.apply.A(x) - y);
        w = w + t*(x - u);

        if i.verbose == 1
            s = DeblurStuff.utilities.evalperf(x,b);
            fprintf('Iter %.3i and the mse is %.3f \n', iter, s);
        end

    end

    x = ivals.apply.invertMatrix(u + ivals.apply.ATrans(y) - ...
        t^(-1)*(w + ivals.apply.ATrans(z)));
    summary = "Algorithm Ended";

end






