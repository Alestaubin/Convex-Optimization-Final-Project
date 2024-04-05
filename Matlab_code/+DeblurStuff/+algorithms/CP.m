function algo = CP()
    algo.initialize =@(xinit, b, kernel, i) CP_init( xinit, b, i );
    algo.iterate =@(ivals, b, kernel, i, problem ) CP_run( ivals, b, i, problem );
end

function ivals = CP_init(xinit, b, i)
    % initialize values 
    
end

function CP_run(ivals, b, i, problem)
    %initialize values
    s = i.schambollepock;
    t = i.tchambollepock;

    prox_sgstar = @(y);
    prox_tf = @(y); 

    
end