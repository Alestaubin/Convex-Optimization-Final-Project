function [ivals, i] = init_algo( algorithm, i, b, xinit, kernel )
arguments
    algorithm char {mustBeMember(algorithm,{'douglasrachfordprimaldual','douglasrachfordprimal', 'admm', 'chambollepock'})}
    i struct
    b (:,:,1) double
    xinit (:,:) double 
    kernel 
end
% Takes as input the algorithm name, and returns the initial values in a
% struct ivals

%get the transformations
ivals.apply = DeblurStuff.utilities.multiplyingmatrix(b, kernel);

ivals.x = xinit;
[numRows, numCols] = size(b);

if ~isfield(i, 'maxiter'), i.maxiter=500 ; end
if ~isfield(i, 'gammal1'), i.gammal1 = 0.049; end
if ~isfield(i, 'gammal2'), i.gammal2 = 0.049; end

switch algorithm
    case 'douglasrachfordprimal'

        % check i params
        if ~isfield(i, 'rhoprimaldr'), i.rhoprimaldr=2 ; end
        if ~isfield(i, 'tprimaldr'), i.tprimaldr=1.50 ; end

        %set init values 
        ivals.z1 = xinit;
        %ivals.z1 = b;
        ivals.z2 = cat(3, ivals.apply.K(xinit), ivals.apply.D(xinit));
        %ivals.z2 = zeros(numRows, numCols, 3);

    case 'douglasrachfordprimaldual'
         
        % check i params
        if ~isfield(i, 'tprimaldualdr'), i.tprimaldualdr = 0.5; end
        if ~isfield(i, 'rhoprimaldualdr'), i.rhoprimaldualdr = 1.049; end
       
        ivals.p0 = xinit;
        %ivals.p0 = b;
        ivals.q0 = cat(3, ivals.apply.K(xinit), ivals.apply.D(xinit));
        %ivals.q0 = zeros(numRows, numCols, 3);

    case 'admm'
        
        % check i params
        if ~isfield(i, 'tadmm'), i.tadmm = 0.5; end
        if ~isfield(i, 'rhoadmm'), i.rhoadmm = 1.049; end

        

    case 'chambollepock'

        % check i params
        if ~isfield(i, 'tcp'), i.tcp = 0.2; end
        if ~isfield(i, 'scp'), i.scp = 0.1; end

        % initialize x,y,z
        %ivals.x = b;
        ivals.y = zeros(numRows, numCols, 3);
        ivals.z = b;

end

