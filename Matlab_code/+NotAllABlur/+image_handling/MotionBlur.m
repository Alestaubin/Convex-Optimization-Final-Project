function blurredImage = MotionBlur(unblurredImage, len, theta)
% INPUTS: 
% - unblurredImage is unambiguous. 
% - len is linear motion of camera, specified as a numeric scalar, 
%   measured in pixels.
% - theta is the angle of camera motion in degrees, specified as a numeric
%   scalar. The angle is measured in a counter-clockwise direction from horizontal.
% OUTPUT:
% Applies a motion blur to unblurredImage and returns the result.
H = fspecial('motion',len,theta);
blurredImage = imfilter(unblurredImage,H, "replicate");
end

