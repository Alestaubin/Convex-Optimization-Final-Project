
%%%%%%%%%%%%%%
% Algorithm 2: douglasrachfordprimaldual
%%%%%%%%%%%%%%

function [ x, summary ] = DRPD( ivals, b, i, problem )
arguments
    ivals 
    b 
    i 
    problem 
end
%% Initialize the values
    apply = ivals.apply;

    pk = ivals.p0;
    qk = ivals.q0;
    
    t = i.tprimaldualdr;
    rho = i.rhoprimaldualdr;

    % select the norm (l1 or l2)
    [ prox_phi, gamma ] = DeblurStuff.utilities.problemSelect(problem, b, t, i);
    
 %% Set up the proximal operators 
    % (the same notation as in the report is used).
    prox_f = @(x) DeblurStuff.utilities.prox.boxprox( x );

    prox_psi = @(y2) DeblurStuff.utilities.prox.isoprox(y2, gamma * t);

    prox_g = @(y) cat(3, ... % to concatenate the matrices in the 3rd dimension
        prox_phi(y(:,:,1)), ... % pass the top matrix of y to l1prox function
        prox_psi(y(:,:,2:3))); % pass the 2 bottom matrices of y to the isoprox function

    %prox_g = @(x) DeblurStuff.utilities.prox.prox_g(problem, b, i, x, t);
    %Taking the conjugate of the prox
    prox_gconj = @(y) DeblurStuff.utilities.prox.conjugate_one(prox_g, y, t);
    

    

%% Main loop
    for j=1:i.maxiter
        %x_prev = xk; %this will be used to calculate error
        % Resolvent of A
        xk = prox_f( pk );
        zk = prox_gconj( qk );

        %temp vars
        temp_zq = (2 * zk) - qk;
        temp_xp = (2 * xk) - pk;

        % Resolvent of B
        wk = apply.invertMatrix(temp_xp) - t * apply.invertMatrix(apply.ATrans(temp_zq));
        vk = temp_zq + t * apply.A(apply.invertMatrix(temp_xp)) - (t^2) * apply.A(apply.invertMatrix(apply.ATrans(temp_zq)));
        
        pk = pk + rho * (wk - xk);
        qk = qk + rho * (vk - zk);
        
        if i.verbose == 1
            s = DeblurStuff.utilities.evalperf(xk,b);
            fprintf('Iter %.2i and the mse is %.3f \n', j, s);
        end
    
    end

    x = prox_f( pk );
    summary = "Algorithm Ended";

end




