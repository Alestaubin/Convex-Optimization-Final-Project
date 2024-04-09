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
    % Initialize values
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
    
end
