
% A script to display blurred and unblurred versions of the same image

clc;
clearvars; 

I = imread('+TheProject/+image_files/mcgill.jpg'); % read the image
figure('Name','Image before blurring'); % set the title of the figure
imshow(I,[]) % display the unblurred image 
J = TheProject.image_handling.GaussianBlur(I,50,10); % add the blur
figure('Name','image after deblurring'); % set the title of the second figure   
imshow(J,[]) % display the blurred image