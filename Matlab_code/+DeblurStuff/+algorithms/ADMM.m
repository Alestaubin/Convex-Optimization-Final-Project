
%%%%%%%%%%%%%%%%%%%%
% Algorithm 3: admm
%%%%%%%%%%%%%%%%%%%%
function algo = ADMM()
    algo.initialize =@(xinit, b, kernel, i) admm_init( xinit, b, kernel, i );
    algo.iterate =@(ivals, b, kernel, i, problem ) admm_run( ivals, b, kernel, i, problem );
end

function ivals = admm_init( xinit, b, kernel, i)

    if ~isfield(i, 'tadmm'), i.tadmm = 2.0 ; end
    if ~isfield(i, 'rhoadmm'), i.rhoadmm = 0.05; end

    apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);
    ivals.u = xinit;
    ivals.y = cat(3, apply.K(xinit), apply.D(xinit));
    ivals.w = xinit;
    ivals.z = cat(3, apply.K(xinit), apply.D(xinit));
end

function [ x, summary ] = admm_run( ivals, b, kernel, i, problem )
%% get the transformations
    apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);

%%  Initialize the values
    u = ivals.u;
    y = ivals.y;
    w = ivals.w;
    z = ivals.z;

    t = i.tprimaldr;
    rho = i.rhoprimaldr;

%% Set up the proximal operators 
    % prox of 
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );

    % select the norm (l1 or l2)
    [ prox_phi, gamma ] = DeblurStuff.utilities.problemSelect(problem, b, t, i);
    prox_psi = @(y2) DeblurStuff.utilities.prox.isoprox( y2, 1/(gamma * t) );

    prox_g = @(y) cat(3, ... % to concatenate the matrices in the 3rd dimension
        prox_phi(y(:,:,1)), ... % pass the top matrix of y to l1prox function
        prox_psi(y(:,:,2:3))); % pass the 2 bottom matrices of y to the isoprox function

%% Main loop
    for j=1:i.maxiter
        x = apply.invertMatrix(u + apply.ATrans(y) - t^(-1)*(w + apply.ATrans(z)));
        u = prox_f(rho*x + (1-rho)*u + w/t);
        y = prox_g(rho*apply.A(x) + (1-rho)*y + z/t);
        w = w + t*(x - u);
        z = z + t*(apply.A(x) - y);
    end

    x = apply.invertMatrix(u + apply.ATrans(y) - t^(-1)*(w + apply.ATrans(z)));
    summary = "Algorithm Ended";

end





