function apply = multiplyingmatrix(b, kernel, t)
% MULTIPLYINGMATRIX Facilitates computation of matrix inverses
%
%
%   Input parameters :
%       b       : Blurred image
%       kernel  : Convolution kernel
%       t       : Step size hyperparameter
%   Output parameters :
%       apply   : Struct with helper functions
%
%
% Helper function. Modified from the given code. Allows for convenient 
% function calls by the Matlab structure.
%
%
arguments
    b 
    kernel 
    t = 1 % per message on mycourses posted on Mar 29, 2024 3:37 PM
end
%Constructing the K and D matrices
[numRows, numCols] = size(b); %numRows = m, numCols = n

%computes the numRow x numCol matrix of the eigenvalues for K and D1 and
%D2; Here D1 = I oplus D1 in the paper and D2 = D1 oplus I.
eigArry_K = DeblurStuff.utilities.eigValsForPeriodicConvOp(kernel, numRows, numCols);
eigArry_D1 = DeblurStuff.utilities.eigValsForPeriodicConvOp([-1,1]', numRows, numCols);
eigArry_D2 = DeblurStuff.utilities.eigValsForPeriodicConvOp([-1,1], numRows, numCols);

%computes numRow x numCol matrix of the eigenvalues for K^T and D1^T and
%D2^T;
eigArry_KTrans = conj(eigArry_K);
eigArry_D1Trans = conj(eigArry_D1);
eigArry_D2Trans = conj(eigArry_D2);

%Functions which compute Kx, D1x, D2x, Dxt, K^Tx, D1^Tx, D2^Tx, and D^Ty.
%Note for all the x functions, the input x is in R^(m x n) and outputs into
%R^(m x n) except for D which outputs into 2 concat. R^(m x n) matrices;
%For D^Ty, y is two m x n matrices concatanated and outputs into R^(m x n)
applyD1 = @(x) DeblurStuff.utilities.applyPeriodicConv2D(x, eigArry_D1);
applyD2 = @(x) DeblurStuff.utilities.applyPeriodicConv2D(x, eigArry_D2);
applyD1Trans = @(x) DeblurStuff.utilities.applyPeriodicConv2D(x, eigArry_D1Trans);
applyD2Trans = @(x) DeblurStuff.utilities.applyPeriodicConv2D(x, eigArry_D2Trans);

apply.K = @(x) DeblurStuff.utilities.applyPeriodicConv2D(x, eigArry_K);
apply.KTrans = @(x) DeblurStuff.utilities.applyPeriodicConv2D(x, eigArry_KTrans);

apply.D = @(x) cat(3, applyD1(x), applyD2(x));
apply.DTrans = @(y) applyD1Trans(y(:,:,1)) + applyD2Trans(y(:, :, 2));

apply.A = @(x) cat(3, apply.K(x), applyD1(x), applyD2(x));
apply.ATrans = @(y) apply.KTrans(y(:,:,1)) + apply.DTrans(y(:,:,2:3));

% Function which computes the (I + K^TK + D^TD)x where x in R^(m x n)
% matrix and the eigenvalues of I + t*t*K^TK + t*t*D^TD; here t is the
% stepsizes
apply.Mat = @(x) x + apply.KTrans(apply.K(x)) + apply.DTrans(apply.D(x));
apply.eigValsMat = ones(numRows, numCols) + ...
                t*t*eigArry_KTrans.*eigArry_K + ...
                t*t*eigArry_D1Trans.*eigArry_D1 + ...
                t*t*eigArry_D2Trans.*eigArry_D2;

%R^(m x n) Computing (I + K^T*K + D^T*D)^(-1)*x
apply.invertMatrix = @(x) ifft2(fft2(x)./(apply.eigValsMat)); 
end