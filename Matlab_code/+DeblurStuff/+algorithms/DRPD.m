
%%%%%%%%%%%%%%
% Algorithm 2: douglasrachfordprimaldual
%%%%%%%%%%%%%%
function algo = DRPD()
    algo.initialize =@(xinit, b, kernel, i) drfpd_init( xinit, b, kernel, i );
    algo.iterate =@(ivals, b, kernel, i, problem ) drfpd_run( ivals, b, kernel, i, problem );
end


function ivals = drfpd_init( xinit, b, kernel, i )

    if ~isfield(i, 'gammal1'), i.gammal1 = 0.049; end
    if ~isfield(i, 'tprimaldualdr'), i.tprimaldualdr = 0.5 ; end
    if ~isfield(i, 'rhoprimaldualdr'), i.rhoprimaldualdr = 0.05; end
    
    apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);
    ivals.z1 = xinit;
    %ivals.z1 = b;
    ivals.z2 = cat(3, apply.K(xinit), apply.D(xinit));
    %dim = size(b);
    %ivals.z2 = zeros(dim(1), dim(2), 3);
end








function [outputArg1,outputArg2] = DRPD(inputArg1,inputArg2)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end