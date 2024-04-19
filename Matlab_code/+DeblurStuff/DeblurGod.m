function sol = DeblurGod( problem, algo, xinit, kernel, b, i )
% DEBLURGOD Attempts to deblur an image.
% 
%
%   Input parameters :
%       problem : "l1" or "l2" problem
%       algo    : Algorithm to be run
%       xinit   : Initial values
%       kernel  : Convolution kernel
%       b       : Blurred image
%       i       : Struct of parameters
%   Output parameters :
%       sol     : Optimized image
%
%  
% Considers a general convex optimization problem of the form
%
%               min_{x, y} f(x) + g(y)
%   subject to  Ax = y
%
% where
%   f(x) = \delta_S(x)      S = {x : 0 <= x <= 1}
%   g(y) will be determined by the l1 or the l2 problem, of the form
%       g(y1, y2, y3) = \| y1 - b \|_{1 or 2} _ gamma \|(y2, y3)\|_{iso}
%
%
% `problem` is a string between "l1" or "l2"
%
% `algo` is a string among
%   - 'douglasrachfordprimaldual'
%   - 'douglasrachfordprimal'
%   - 'admm'
%   - 'chambollepock'
%
% `kernel` is a 2D filter
%
% `i` is a Matlab structure containing the following fields:
%   - verbose : 1 to print each iteration
%   - malength : moving average window for early stopping
%   - maxiter : maximum number of iterations
%   - gammal1 : iso norm constant under the 'l1' problem
%   - gammal2 =: iso norm constant under the 'l2' problem
%   - tprimaldr : Parameter for Primal Douglas-Rachford
%   - rhoprimaldr : Parameter for Primal Douglas-Rachford
%   - tprimaldualdr : Parameter for Primal-Dual Douglas-Rachford
%   - rhoprimaldualdr : Parameter for Primal-Dual Douglas-Rachford
%   - tadmm : Parameter for ADMM
%   - rhoadmm : Parameter for ADMM
%   - scp : Parameter for Chambolle-Pock
%   - tcp : Parameter for Chambolle-Pock
%
%
arguments
    problem {mustBeMember(problem,{'l1','l2'})}
    algo {mustBeMember(algo,{'douglasrachfordprimaldual','douglasrachfordprimal', 'admm', 'chambollepock'})}
    xinit 
    kernel 
    b 
    i 
end
%% Set up the algorithm
    % Initialize values
    fprintf("###############################################\n");
    fprintf("Running algorithm %s...\n", lower(algo));
    tic
    
    % Taper edges to avoid edge ringing
    b = edgetaper (b, kernel);

    [ivals, i] = DeblurStuff.init.init_algo( algo, i, b, xinit, kernel );
    
    switch lower(algo)
        case 'douglasrachfordprimal'
            [ sol, summary ] = DeblurStuff.algorithms.DRP(ivals, b, i, problem);
        case 'douglasrachfordprimaldual'
            [ sol, summary ] = DeblurStuff.algorithms.DRPD(ivals, b, i, problem);
        case 'admm'
            [ sol, summary ] = DeblurStuff.algorithms.ADMM(ivals, b, i, problem);
        case 'chambollepock'
            [ sol, summary ] = DeblurStuff.algorithms.CP(ivals, b, i, problem);
    end
    
    % Display the results
    fprintf("\n");
    fprintf("The algorithm ran in %i iterations. \n" + ...
        "The final objective value is %.6f. \n", ...
        summary.iter, summary.e);
    toc
    fprintf("###############################################\n");
end
