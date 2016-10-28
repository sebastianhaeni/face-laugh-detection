clear all; close all; clc;

fontSize = 16;
fullImageFileName = 'images/group2/02.JPG';


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
structuringElement = strel('disk', 60);
coloredObjectsMask = imerode(coloredObjectsMask, structuringElement);
coloredObjectsMask = imdilate(coloredObjectsMask, structuringElement);

imshow(coloredObjectsMask, []);
pause;    

T = imread('mean.jpg');
G = rgb2gray(rgbImage);
C = normxcorr2(T, G);

pos_e99 = C > 0.99; %positions w. CC > 0.99
pos_e95 = C > 0.95; %positions w. CC > 0.95
pos_e85 = C > 0.85; %positions w. CC > 0.85
pos_e75 = C > 0.75; %positions w. CC > 0.85

% Mark positions with high correlation
imshow(G), title('red>99%, green>95%, blue>85%, yellow>75%'); hold on
ps = size(t,1)/2;
for y=1:size(pos_e99,2)
   for x=1:size(pos_e99,1)
      if pos_e99(x,y)==1
         plot(y-ps,x-ps,'x','LineWidth',3,'Color','red');
      elseif pos_e95(x,y)==1
         plot(y-ps,x-ps,'x','LineWidth',3,'Color','green');
      elseif pos_e85(x,y)==1
         plot(y-ps,x-ps,'x','LineWidth',3,'Color','blue');
      elseif pos_e75(x,y)==1
         plot(y-ps,x-ps,'x','LineWidth',3,'Color','yellow');
      end
   end
end



