clear all; clear clc; close all;

facesPath = '/Users/rlaubscher/Dropbox/BFH/CPVR2-3-CP/Exercises/Images/cpvr_classes/2016HS/_DSC0380.JPG';
I = imread(facesPath);

faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, I);
numRows = size(bboxes, 1);

means = [];
k = 0;

for i=1:1:numRows
    % [x, y, width, height]
    bbox = bboxes(i,:);
    if bbox(3) < 100
        continue;
    end;
    bbox(2) = bbox(2) - 50;
    bbox(4) = bbox(4) + 50;
    subImage = imcrop(I, bbox);
    hsvI = rgb2hsv(subImage);
    h = hsvI(:,:,1);
    if mean2(h) > 0.3
        continue;
    end;
    k = k + 1;
    imwrite(subImage, sprintf('./images/search/%d.png', k));
end;

IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
figure, imshow(IFaces), title('Detected faces');

