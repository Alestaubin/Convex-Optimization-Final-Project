
%%%%%%%%%%%%%%%%%%%%
% Algorithm 1: douglasrachfordprimal
%%%%%%%%%%%%%%%%%%%%
function algo = DRP()
    algo.initialize =@(xinit, b, kernel, i) drfp_init( xinit, b, kernel, i );
    algo.iterate =@(ivals, b, kernel, i, g) drfp_run( ivals, b, kernel, i, g );
end


function ivals = drfp_init( xinit, b, kernel, i )
    i.algo = 'douglasrachfordprimal';
    if ~isfield(i, 'gammal1'), i.gammal1 = 0.049; end
    if ~isfield(i, 'tprimaldr'), i.tprimaldr = 2.0 ; end
    if ~isfield(i, 'rhoprimaldr'), i.rhoprimaldr = 0.05; end
    
    apply = NotAllABlur.utilities.multiplyingmatrix(b, kernel, i);
    ivals.z1 = xinit;
    ivals.z2 = cat(3, apply.K(xinit), apply.D(xinit));
end


function [ x, summary ] = drfp_run( ivals, b, kernel, i, g )
    apply = NotAllABlur.utilities.multiplyingmatrix(b, kernel, i);
    
    iter = 1;
    z1 = ivals.z1;
    z2 = ivals.z2;
    while (iter <= i.maxiter)
        % Resolvent of A
   
        % x is an n x m matrix 
        x = NotAllABlur.utilities.prox.boxprox( z1 );
        % y is 3 x n x m
        y = cat(3, ... % to concatenate the matrices in the 3rd dimension
            g( z2(:, :, 1), b, i.gammal1 ), ... % pass the top 2d matrix of z2 to l1prox function 
            NotAllABlur.utilities.prox.isoprox( z2(:, :, 2:3),i.gammal1 ) ... % pass the 2 bottom 2d matrices of z2 to the isoprox function
            );

        % Resolvent of B
        u = apply.invertMatrix( ...
            2*x - z1 + ...
            apply.KTrans(2*y(:, :, 1) - z1(:, :, 1)) + ...
            apply.DTrans(2*y(:, :, 2:3) - z2(:, :, 2:3)));

        v = cat(3, apply.K(u), apply.D(u));
        
        % Update
        z1 = z1 + i.rhoprimaldr*(u - x);
        z2 = z2 + i.rhoprimaldr*(v - y);
        iter = iter + 1;
    
        if i.verbose == 1
            fprintf('Iter %.2i   \n', iter);
        end
    
    end

    x = NotAllABlur.utilities.prox.boxprox(z1);  
    summary = "Algorithm Ended";

end