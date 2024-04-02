function noisedImage = SaltnPepper(unblurredImage, density)
% INPUTS: 
% - unblurredImage is unambiguous. 
% - density: 0.05 will affect roughly 5% of pixels
% OUTPUT:
% Applies salt and pepper noise to unblurredImage and returns the result.
noisedImage = imnoise(unblurredImage, 'salt & pepper', density);
end

