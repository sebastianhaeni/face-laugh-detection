clear all; close all; clc; %clear matrices, close figures & clear cmd wnd.

%% Step 1: Load face images & convert each image into a vector of a matrix
k = 0;
for i=1:1:10
    for j=1:1:10
        filename  = sprintf('./images/cpvr_faces_160/00%2.2d/%2.2d.JPG',i,j);
        I = imread(filename);
        image_data = rgb2gray(I);
        k = k + 1;
        faces(:,k) = image_data(:);
     end;
end;
nImages = k;                     %total number of images
imsize = size(image_data);       %size of image (they all should have the same size) 
nPixels = imsize(1)*imsize(2);   %number of pixels in image
faces = double(faces)/255;       %convert to double and normalize

%% Step 2: Calculate & show the mean image and shift all faces by it
mn = mean(faces, 2);
for i=1:nImages
    faces(:,i) = faces(:,i)-mn;          % substruct the mean
end;
figure('Color',[1 1 1]); 

I = reshape(mn, imsize);

imshow(I); title('mean face');

imwrite(I, 'mean.jpg');

