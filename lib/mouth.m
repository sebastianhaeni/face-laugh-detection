function [ M ] = mouth( FACE )
%MOUTH Summary of this function goes here
%   Detailed explanation goes here

mouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 16);
bboxes = step(mouthDetector, FACE);

bbox = bboxes(1, :);
M = imcrop(FACE, bbox);
imshow(M);
end

