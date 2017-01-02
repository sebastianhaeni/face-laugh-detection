clear all; clear clc; close all;

img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/test_positive_2.jpg');

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

% Mouth image
mouth = imcrop(img, bbox(5:8));
figure; imshow(mouth);

% smiling_factor = get_smile_factor(mouth);    % Determine smile amount

% check for teeth

% get_smile_teeth(mouth);

bw = rgb2gray(mouth);
corners = detectHarrisFeatures(bw);
figure;imshow(bw); hold on;
plot(corners.selectStrongest(50));

coordinates = corners.selectStrongest(50).Location;
left = coordinates(coordinates == min(coordinates(:,1)),:);
right = coordinates(coordinates == max(coordinates(:,1)),:);
bottom = coordinates(coordinates(:,2) == max(coordinates(:,2)), :);

plot(left(:,1), left(:,2), '+r');
plot(right(:,1), right(:,2), '+r');
plot(bottom(:,1), bottom(:,2), '+r');