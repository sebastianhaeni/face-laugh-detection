clear all; clear clc; close all;

% folder = '/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/positive/';
folder = '/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/test';

% outputFolder = '/Users/rlaubscher/projects/bfh/face-laugh-detection/images/mouth/positive/';
outputFolder = '/Users/rlaubscher/projects/bfh/face-laugh-detection/images/mouth/test';

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

count = 1;

for s=1:5
    img = imread(sprintf('%s/smile%d.jpg', folder, s));
    img = imgaussfilt(img, 2);

    [bbox bbimg faces bbfaces] = detectMouth(detectors,img,2);
    
    if size(faces, 1) > 1
        continue;
    end
    
    % Mouth image
    mouth = imcrop(img, bbox(5:8));
%     figure; imshow(mouth);
    
    bw = rgb2gray(mouth);
    % bw = mouth;
    bw = histeq(bw);
    % meanBW = mean2(bw);
    % bw = bw + meanBW;
%     bw = imgaussfilt(bw, 1);
    % imshow(bw);
    scaled = imresize(bw, [70, 115]);
    imwrite(scaled, sprintf('%s/smile%d.jpg', outputFolder, count));
    count = count + 1;
end

% img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/negative/2.jpg');
% img = imread('/Users/rlaubscher/projects/bfh/face-laugh-detection/images/smile/positive/s2.jpg');
% img = imread('/Users/rlaubscher/Dropbox/BFH/CPVR2-3-CP/Exercises/Images/att_faces/s8/3.pgm');



