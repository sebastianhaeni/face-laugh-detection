clear all; clear clc; close all;

folder = 'images/mouth/negative';

for s=1:44
    img = imread(sprintf('%s/%d.jpg', folder, s));
    
    scaled = imresize(img, [70, 115]);
    
    imwrite(scaled, sprintf('%s/scaled/%d.jpg', folder, s));
end

% img = imread('images/smile/negative/2.jpg');
% img = imread('images/smile/positive/s2.jpg');

