clear all; clear clc; close all;

facesPath = '/Users/rlaubscher/projects/bfh/face-laugh-detection/images/cpvr_faces_160/0004/01.JPG';
I = imread(facesPath);

faceDetector = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);
G = rgb2gray(I);

bboxes = step(faceDetector, I);

% corners = detectHarrisFeatures(G);
% imshow(G); hold on;
% plot(corners.selectStrongest(50));
% pause;

% lips = imcrop(G,bboxes);
% C = corner(lips);
% 
% imshow(lips);
% hold on;
% plot(C(:,1), C(:,2), 'r*');

IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Mouth');
figure, imshow(IFaces), title('Detected mouth');

