%%%%%%%%%%%%%%%%%%%%
% Image Set up
%%%%%%%%%%%%%%%%%%%%
clearvars, clc;
% Import image
I = imread('+NotAllABlur/+image_files/cameraman.jpg');
I = rgb2gray(I);

% Resize so each pixel is in between 0 and 1
I = double(I(:, :, 1));
mn = min(I(:));
I = I - mn;
mx = max(I(:));
I = I/mx;

% Show image
 figure('Name','image before deblurring')
 imshow(I,[])


%%%%%%%%%%%%%%%%%%%%
% Convolution kernels and noise (at least 2 variations of each)
%%%%%%%%%%%%%%%%%%%%

[kernel,b] = NotAllABlur.image_handling.GaussianBlur(I,5,2);
b = NotAllABlur.image_handling.SaltnPepper(b, 0.10);
figure('Name','image after blurring')
imshow(b,[])


%%%%%%%%%%%%%%%%%%%%
% Algorithm setups
%%%%%%%%%%%%%%%%%%%%

i.verbose = 1;
i.maxiter = 200;
i.gammal1 = 0.75;
i.tprimaldr = 0.9;
i.rhoprimaldr = 0.1;
i.tprimaldualdr = 2.0;
i.rhoprimaldualdr = 1.049;
[numRows, numCols] = size(b);
x = rand_init( numRows, numCols );
[x, summary] = optsolve('l1', 'douglasrachfordprimal', x, kernel, b, i);
% x = optsolve('l1', 'douglasrachfordprimal', x, kernel, b, i);
% x = optsolve('l1', 'douglasrachfordprimaldual' , x, kernel, b, i);

figure('Name','image after deblurring')
imshow(x,[])

% Random initialization
function [ out ] = rand_init( numRows, numCols )
    out = rand(numRows, numCols);
end

function [ sol, summary ] = optsolve( problem, algo, xinit, kernel, b, i )
    % Set up the algorithm
    algo = algoname(algo);
    g = probname(problem);
    if ~isfield(i, 'maxiter'), i.maxiter=500 ; end
    
    % Initialize values
    ivals = algo.initialize( xinit, b, kernel, i );
    
    % Optimize
    [ sol, summary ] = algo.iterate( ivals, b, kernel, i, g );
end


% Select algorithm
function algo = algoname( name )
    switch lower(name)
        case 'douglasrachfordprimal'
            algo = NotAllABlur.algorithms.DRP();
        case 'douglasrachfordprimaldual'
            algo = NotAllABlur.algorithms.DRPD();
        case 'admm'
            algo = NotAllABlur.algorithms.ADMM();
        case 'chambollepock'
            algo = NotAllABlur.algorithms.CP();
        otherwise
            error('Unknown algorithm name');
    end
end

function problem = probname( name )
    switch lower(name)
        case 'l1'
            problem =@(y, b, t) NotAllABlur.utilities.prox.l1prox( y, b, t );
        case 'l2'
            problem =@(y, b, t) NotAllABlur.utilities.prox.l2Prox( y, b, t );
        otherwise
            error('Unknown algorithm name');
    end
end