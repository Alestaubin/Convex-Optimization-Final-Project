function algo = CP()
    algo.initialize =@(xinit, b, kernel, i) CP_init( xinit, b, i );
    algo.iterate =@(ivals, b, kernel, i, problem ) CP_run( ivals, b, kernel, i, problem );
end

function ivals = CP_init(~, ~, ~)
    % initialize values 
    ivals = 0;
end

function [x_sol, summary] = CP_run(~, b, kernel, i, problem)
    %initialize values
    s = i.schambollepock;
    t = i.tchambollepock;

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

    prox_gstar = @(y) DeblurStuff.utilities.prox.conjugate(prox_g, y, t);
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );
    
    % get the dimensions of b (the blurred image)
    [numRows, numCols] = size(b);

    % initialize x,y,z
    x = b;
    y = zeros(numRows, numCols, 3);
    z = b;

 %% get the transformations
    apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);
    
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