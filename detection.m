clear all; close all; clc;

fontSize = 16;
fullImageFileName = 'images/group1.jpg';


[rgbImage, storedColorMap] = imread(fullImageFileName); 
[rows, columns, numberOfColorBands] = size(rgbImage); 

% Convert RGB image to HSV
hsvImage = rgb2hsv(rgbImage);
% Extract out the H, S, and V images individually
hImage = hsvImage(:,:,1);
vImage = hsvImage(:,:,2);


%imshow(hImage);
%pause;
%imshow(vImage);
%pause;

hueThresholdLow = 0;
hueThresholdHigh = graythresh(hImage) * .25;
valueThresholdLow = graythresh(vImage);
valueThresholdHigh = 1.0;

hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);

coloredObjectsMask = uint8(hueMask & valueMask);
coloredObjectsMask = uint8(bwareaopen(coloredObjectsMask, 3000));

structuringElement = strel('disk', 30);
coloredObjectsMask = imclose(coloredObjectsMask, structuringElement);

imshow(coloredObjectsMask, []);
    




