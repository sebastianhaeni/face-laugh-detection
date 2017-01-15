function [ F ] = face( I )
%FACE Summary of this function goes here
%   Detailed explanation goes here

faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, I);

bbox = bboxes(1, :);
F = imcrop(I, bbox);

end

