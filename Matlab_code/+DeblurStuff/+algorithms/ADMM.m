
%%%%%%%%%%%%%%%%%%%%
% Algorithm 1: admm
%%%%%%%%%%%%%%%%%%%%
function algo = ADMM()
    algo.initialize =@(xinit, b, kernel, i) admm_init( xinit, b, kernel, i );
    algo.iterate =@(ivals, b, kernel, i, problem ) drfp_run( ivals, b, kernel, i, problem );
end

function ivals = admm_init( xinit, b, kernel, i)

    if ~isfield(i, 'tadmm'), i.tprimaldr = 2.0 ; end
    if ~isfield(i, 'rhoadmm'), i.rhoprimaldr = 0.05; end

    apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);
    ivals.z1 = xinit;
    ivals.z2 = cat(3, apply.K(xinit), apply.D(xinit));

end





function [outputArg1,outputArg2] = ADMM(inputArg1,inputArg2)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here




outputArg1 = inputArg1;
outputArg2 = inputArg2;


end