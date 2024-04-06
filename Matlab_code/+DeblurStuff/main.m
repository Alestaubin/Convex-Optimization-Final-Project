%%%%%%%%%%%%%%%%%%%%
% Image Set up
%%%%%%%%%%%%%%%%%%%%
clearvars, clc;
% Import image
I = imread('+DeblurStuff/+image_files/cameraman.jpg');
I = rgb2gray(I);

% Resize so each pixel is in between 0 and 1
I = double(I(:, :, 1));
mn = min(I(:));
I = I - mn;
mx = max(I(:));
I = I/mx;

% Show image
% figure('Name','image before deblurring')
% imshow(I,[])


%%%%%%%%%%%%%%%%%%%%
% Convolution kernels and noise (at least 2 variations of each)
%%%%%%%%%%%%%%%%%%%%

%[kernel,b] = DeblurStuff.image_handling.GaussianBlur(I,5,2);
[kernel, b] = DeblurStuff.image_handling.MotionBlur(I,10,0);
b = DeblurStuff.image_handling.SaltnPepper(b, 0.01);
% figure('Name','image after blurring')
% imshow(b,[])


%%%%%%%%%%%%%%%%%%%%
% Algorithm setups
%%%%%%%%%%%%%%%%%%%%

i.verbose = 1;
i.maxiter = 200;
i.gammal1 = 0.1;
i.gammal2 = 0.1;
i.tprimaldr = 2;
i.rhoprimaldr = 1.50;
i.tprimaldualdr = 0.5;
i.rhoprimaldualdr = 1.049;
i.scp = 0.2; 
i.tcp = 0.2;
[numRows, numCols] = size(b);
x = zeros( numRows, numCols );
[x, summary] = DeblurStuff.DeblurGod('l1', 'douglasrachfordprimal', x, kernel, b, i);
% [x, summary] = DeblurStuff.DeblurGod('l1', 'chambollepock', x, kernel, b, i);

% x = optsolve('l1', 'douglasrachfordprimal', x, kernel, b, i);
% x = optsolve('l1', 'douglasrachfordprimaldual' , x, kernel, b, i);

figure('Name','image after deblurring')
imshow(x,[])
