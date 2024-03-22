function noisedImage = Poisson(unblurredImage)
% INPUTS: 
% - unblurredImage is unambiguous. 
% OUTPUT:
% Applies poisson noise to unblurredImage and returns the result.
noisedImage = imnoise(unblurredImage,'poisson');
end

