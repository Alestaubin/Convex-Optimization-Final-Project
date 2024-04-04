
%%%%%%%%%%%%%%%%%%%%
% Algorithm 1: douglasrachfordprimal
%%%%%%%%%%%%%%%%%%%%
function algo = DRP()
    algo.initialize =@(xinit, b, kernel, i) drfp_init( xinit, b, kernel, i );
    algo.iterate =@(ivals, b, kernel, i, problem ) drfp_run( ivals, b, kernel, i, problem );
end


function ivals = drfp_init( xinit, b, kernel, i )

    if ~isfield(i, 'gammal1'), i.gammal1 = 0.049; end
    if ~isfield(i, 'tprimaldr'), i.tprimaldr = 2.0 ; end
    if ~isfield(i, 'rhoprimaldr'), i.rhoprimaldr = 0.05; end
    
    apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);
    ivals.z1 = xinit;
    %ivals.z1 = b;
    ivals.z2 = cat(3, apply.K(xinit), apply.D(xinit));
    %dim = size(b);
    %ivals.z2 = zeros(dim(1), dim(2), 3);
end

function [ x, summary ] = drfp_run( ivals, b, kernel, i, problem )
%% get the transformations
    apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);
    
%% Initialize the values
    z1 = ivals.z1;
    z2 = ivals.z2;
    t = i.tprimaldr;
    rho = i.rhoprimaldr;

    % select the norm (l1 or l2)
    switch lower(problem)
        case 'l1'
            prox_phi =@(y1) DeblurStuff.utilities.prox.l1prox( y1, b, t );
            gamma = i.gammal1;
        case 'l2'
            prox_phi =@(y1) DeblurStuff.utilities.prox.l2Prox( y1, b, t );
            gamma = i.gammal2;
        otherwise
            error('Unknown problem.');
    end
    
 %% Set up the proximal operators 
    % (the same notation as in the report is used).
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );

    prox_psi = @(y2) DeblurStuff.utilities.prox.isoprox(y2, gamma * t);
    
    prox_g = @(y) cat(3, ... % to concatenate the matrices in the 3rd dimension
        prox_phi(y(:,:,1)), ... % pass the top matrix of y to l1prox function
        prox_psi(y(:,:,2:3))); % pass the 2 bottom matrices of y to the isoprox function

%% Algorithm
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
            se = mse(x,b);
            fprintf('Iter %.2i  and the mse is %.3f \n', j, se);
        end
    
    end

    x = prox_f( z1 );
    summary = "Algorithm Ended";

end