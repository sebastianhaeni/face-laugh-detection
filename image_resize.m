clear all; clear clc; close all;

folder = '/Users/rlaubscher/projects/bfh/face-laugh-detection/images/mouth/negative';

for s=1:44
    img = imread(sprintf('%s/%d.jpg', folder, s));
    
    scaled = imresize(img, [70, 115]);
    
    imwrite(scaled, sprintf('%s/scaled/%d.jpg', folder, s));
end

% img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/negative/2.jpg');
% img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/positive/s2.jpg');
% img = imread('/Users/rlaubscher/Dropbox/BFH/CPVR2-3-CP/Exercises/Images/att_faces/s8/3.pgm');



