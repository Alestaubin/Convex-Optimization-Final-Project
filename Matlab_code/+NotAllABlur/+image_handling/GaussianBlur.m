function [kernel, blurredImage]= GaussianBlur(unblurredImage, hsize, sigma)
% INPUTS: 
% - unblurredImage is unambiguous. 
% - hsize is the size of the filter, it should be significantly smaller
%   than the image, something like 15. It is specified as a positive integer 
%   or 2-element vector of positive integers. Use a vector to specify the 
%   number of rows and columns in h. If you specify a scalar,
%   then h is a square matrix.
% - sigma is the standard deviation
% OUTPUT:
% Applies a gaussian blur to unblurredImage and returns the result.
kernel = fspecial('gaussian',hsize,sigma);
blurredImage = imfilter(unblurredImage,kernel, "replicate");
end

