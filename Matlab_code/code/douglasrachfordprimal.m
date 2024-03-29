% i: Input parameter values will be specified by the user through the structure i. 
% You create a structure in Matlab whenever you define a variable with a dot (i.e., .) 
% in its name. For example, your code must allow the user to specify the maximum number 
% of iterations (call it maxiter) and amount of de-noising γ in (1)/(2). 
% Then, a particular call to your program may be the following:
%  » i.maxiter = 500;
%  » i.gammal1 = 0.049;
%  » i.tprimaldr = 2.0;
%  » i.rhoprimaldr = 0.1;
%  » i.tprimaldualdr = 2.0;
%  » i.rhoprimaldualdr = 1.049;
%  » x = optsolve(‘l1’, ‘douglasrachfordprimal’, x, kernel, b, i);
%  » x = optsolve(‘l1’,‘douglasrachfordprimaldual’, x, kernel, b, i);


function [ x, summary ] = douglasrachfordprimal( x_0, kernel, b, i )
% Inputs:
% - x_init : Initializations of vectors needed to solve the algorithm
% - kernel : Kernel for convolution
% - b : blurred image
% - i : struct of parameters
%
% Outputs:
% - x: deblurred image
% - Summary
%   - Problem solved?
%   - Iteration limit?
%   ...
%

% Initialization of vectors
% use the code she gave to 1. compute the eiganvalues for conv,
% then 2. compute y = Ax with applyPeriodicConv. this 'y' will be z2
% so x_0 is a vector of all our initial vectors
% might be better to include the "initialization" in each algorithm
% separatly... but the project pdf initializes x_0 before
z1 = x_0;
z2 = x_0; % (wrong)
n = size(b,2);

while 1

    % Resolvent of A
    x = boxProx(z1, i.step_size);  
    y(1:n) = l1Prox( z2(1:n), i.gammal1);
    y(n+1:3*n) = isoProx( z2(n+1:2*n), z2(2*n+1, 3*n), i.gammaiso);

    % Resolvent of B

end



end