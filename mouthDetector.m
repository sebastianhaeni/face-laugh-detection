clear all; clear clc; close all;

img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/negative/7.jpg');

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

figure;imshow(bbimg);
for i=1:size(bbfaces,1)
 figure;imshow(bbfaces{i});
end