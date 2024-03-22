# Honours Convex Optimization - Final Project 
- See the latex template for the final report [here](/project_template_2024/project_template.pdf)
- See the project proposal [here](/project_proposal/project_proposal.pdf)
- See the final report [here](https://youtu.be/dQw4w9WgXcQ)

## References
- Matlab Namespaces [documentation](https://www.mathworks.com/help/matlab/matlab_oop/namespaces.html;jsessionid=2478e5e942639656d6ca961c0bc5)
- `fspecial` [documentation](https://www.mathworks.com/help/images/ref/fspecial.html)

## Usage 
#### Display an image
Type in the script window, from the directory "+TheProject"
```[MATLAB]
>> I = imread('+TheProject/+image_files/cameraman.jpg'); % set I to the unblurred cameraman image
>> J = TheProject.image_handling.GaussianBlur(I,15,2); % set J to the Gaussian Blurred image
>> figure('Name','image after deblurring'); % sets the title of the figure
>> imshow(J,[]) % displays the image in the figure described above
```
