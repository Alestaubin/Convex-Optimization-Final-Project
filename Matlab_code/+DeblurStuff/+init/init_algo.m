function [ivals, i] = init_algo( problem, algo, i, b, xinit, kernel )
% INIT_ALGO Initializes an optimization algo (helper function)
% 
%
%   Input parameters :
%       algo    : Algorithm to be run
%       i       : Struct of parameters
%       b       : Blurred image
%       xinit   : Initial values
%       kernel  : Convolution kernel
%   Output parameters :
%       ivals   :
%       i       : Struct of parameters
%
%
% Helper function that 
%   - initializes default hyperparameters
%   - initializes algorithm values
%
%
arguments
    algo char {mustBeMember(algo,{'douglasrachfordprimaldual','douglasrachfordprimal', 'admm', 'chambollepock'})}
    i struct
    b (:,:,1) double
    xinit (:,:) double 
    kernel 
end
% Stores utility functions to calculate inverses
ivals.apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);

% Sets some default hyperparameters (see DeblurGod.m for explanation)
if ~isfield(i, 'verbose'), i.verbose = 1 ; end 
if ~isfield(i, 'malength'), i.malength = 32; end
if ~isfield(i, 'maxiter'), i.maxiter = 500 ; end
if ~isfield(i, 'gammal1'), i.gammal1 = 0.01; end
if ~isfield(i, 'gammal2'), i.gammal2 = 0.01; end

% Sets algorithm-specific hyperparameters and initial values
[numRows, numCols] = size(b);
switch algo
    case 'douglasrachfordprimal'
        if strcmp(problem, 'l1')
            if ~isfield(i, 'tprimaldr'), i.tprimaldr=0.5 ; end
            if ~isfield(i, 'rhoprimaldr'), i.rhoprimaldr=1.5 ; end
        else 
            if ~isfield(i, 'tprimaldr'), i.tprimaldr=0.25 ; end
            if ~isfield(i, 'rhoprimaldr'), i.rhoprimaldr=1.5 ; end
        end

        ivals.z1 = xinit;
        ivals.z2 = cat(3, ivals.apply.K(xinit), ivals.apply.D(xinit));

    case 'douglasrachfordprimaldual'
        if strcmp(problem, 'l1')
            if ~isfield(i, 'tprimaldualdr'), i.tprimaldualdr = 0.25; end
            if ~isfield(i, 'rhoprimaldualdr'), i.rhoprimaldualdr = 1.0; end
        else
            if ~isfield(i, 'tprimaldualdr'), i.tprimaldualdr = 1.0; end
            if ~isfield(i, 'rhoprimaldualdr'), i.rhoprimaldualdr = 1.0; end
        end

        ivals.p0 = xinit;
        ivals.q0 = zeros(numRows, numCols, 3);

    case 'admm'
        if strcmp(problem, 'l1')
            if ~isfield(i, 'tadmm'), i.tadmm = 1.0; end
            if ~isfield(i, 'rhoadmm'), i.rhoadmm = 0.01; end
        else
            if ~isfield(i, 'tadmm'), i.tadmm = 0.5; end
            if ~isfield(i, 'rhoadmm'), i.rhoadmm = 0.1; end
        end
        ivals.u = xinit;
        ivals.y = cat(3, ivals.apply.K(xinit), ivals.apply.D(xinit));
        ivals.w = xinit;
        ivals.z = cat(3, ivals.apply.K(xinit), ivals.apply.D(xinit));

    case 'chambollepock'
        if strcmp(problem, 'l1')
            if ~isfield(i, 'tcp'), i.tcp = 1.0; end
            if ~isfield(i, 'scp'), i.scp = 1.0; end
        else 
            if ~isfield(i, 'tcp'), i.tcp = 0.75; end
            if ~isfield(i, 'scp'), i.scp = 0,75; end
        end
        ivals.x = xinit;
        ivals.y = zeros(numRows, numCols, 3);
        ivals.z = b;

end

