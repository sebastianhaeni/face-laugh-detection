clear all; clear clc; close all;

img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/negative/3.jpg');
% img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/positive/s5.jpg');

thresholdFace = 1;
thresholdParts = 1;
stdsize = 176;

mins = [15 25];

detectors.stdsize = stdsize;
detectors.detector = cell(4,1);
minSize = int32([stdsize/5 stdsize/5]);
minSize = [max(minSize(1),mins(1)), max(minSize(2),mins(2))];
detectors.detector{1} = vision.CascadeObjectDetector('FrontalFaceCART', 'MergeThreshold', thresholdFace);
detectors.detector{2} = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', thresholdParts, 'MinSize', minSize);
detectors.detector{3} = vision.CascadeObjectDetector('LeftEye', 'MergeThreshold', thresholdParts, 'MinSize', minSize);
detectors.detector{4} = vision.CascadeObjectDetector('RightEye', 'MergeThreshold', thresholdParts, 'MinSize', minSize);

[bbox bbimg faces bbfaces] = detectMouth(detectors,img,2);

% figure;imshow(bbimg);
% for i=1:size(bbfaces,1)
%  figure;imshow(bbfaces{i});
% end

% Mouth image
mouth = imcrop(img, bbox(5:8));
% figure; imshow(mouth);

bw = rgb2gray(mouth);
bw = imgaussfilt(bw, 1);
SE = strel('diamond',3.0);
bw2 = imdilate(bw,SE);
% bw2 = bw;
corners = detectHarrisFeatures(bw2);
% corners = detectMinEigenFeatures(bw);
% corners = detectFASTFeatures(bw);
figure;imshow(bw2); hold on;
plot(corners.selectStrongest(50));

coordinates = corners.selectStrongest(50).Location;
left = coordinates(coordinates == min(coordinates(:,1)),:);
right = coordinates(coordinates == max(coordinates(:,1)),:);
bottom = coordinates(coordinates(:,2) == max(coordinates(:,2)), :);

plot(left(:,1), left(:,2), '+r');
plot(right(:,1), right(:,2), '+r');
plot(bottom(:,1), bottom(:,2), '+r');

leftAngle = atand((bottom(2)-left(2))/(bottom(1)-left(1)))
rightAngle = atand((bottom(2)-right(2))/(right(1)-bottom(1)))

meanY = mean(coordinates(:,2));
heightBW = size(bw2, 2);
middleLine = [0, meanY; heightBW, meanY];
plot(middleLine(:,1), middleLine(:,2), 'r');

ymin = meanY-0.1*heightBW;
height = 0.25*heightBW;
rect = [0, ymin, size(bw2, 2), height];
lips = imcrop(bw2,rect);

lipCorners = detectHarrisFeatures(lips);
figure;imshow(lips); hold on;
plot(lipCorners.selectStrongest(50));

lipCoord = lipCorners.selectStrongest(50).Location;
meanLipsY = mean(lipCoord(:,2));
heightLipsBW = size(lips, 2);
middleLineLips = [0, meanLipsY; heightLipsBW, meanLipsY];
plot(middleLineLips(:,1), middleLineLips(:,2), 'r');

nearToMean = abs(lipCoord(:,2)-meanLipsY) <= 5;
bestPoints = lipCoord(nearToMean, :);
plot(bestPoints(:,1), bestPoints(:,2), '+y');
