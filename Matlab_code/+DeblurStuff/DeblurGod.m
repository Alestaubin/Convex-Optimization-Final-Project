function [ sol, summary ] = DeblurGod( problem, algo, xinit, kernel, b, i )
arguments
    problem {mustBeMember(problem,{'l1','l2'})}
    algo {mustBeMember(algo,{'douglasrachfordprimaldual','douglasrachfordprimal', 'admm', 'chambollepock'})}
    xinit 
    kernel 
    b 
    i 
end
%% Set up the algorithm
    switch lower(algo)
        case 'douglasrachfordprimal'
            algo = DeblurStuff.algorithms.DRP();
        case 'douglasrachfordprimaldual'
            algo = DeblurStuff.algorithms.DRPD();
        case 'admm'
            algo = DeblurStuff.algorithms.ADMM();
        case 'chambollepock'
            algo = DeblurStuff.algorithms.CP();
    end


    if ~isfield(i, 'maxiter'), i.maxiter=500 ; end
    if ~isfield(i, 'gammal1'), i.gammal1 = 0.049; end
    if ~isfield(i, 'gammal2'), i.gammal1 = 0.049; end
    
    % Initialize values
    ivals = algo.initialize( xinit, b, kernel, i );
    
    % Optimize
    [ sol, summary ] = algo.iterate( ivals, b, kernel, i, problem );
end
