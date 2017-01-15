function [ F, bboxFace ] = face( I )
%FACE Extracts the first face in I

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

