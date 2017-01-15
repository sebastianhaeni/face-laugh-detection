function [ F, bboxFace ] = face( I )
%FACE Summary of this function goes here
%   Detailed explanation goes here

faceDetector = vision.CascadeObjectDetector;
bboxes = step(faceDetector, I);

if size(bboxes, 1) < 1
    F = NaN;
    bboxFace = NaN;
    return;
end

bboxFace = bboxes(1, :);
F = imcrop(I, bboxFace);

end

