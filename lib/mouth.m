function [ M, bboxMouth] = mouth( FACE )
%MOUTH Extracts the MOUTH part in FACE

mouthDetector = vision.CascadeObjectDetector('Mouth', 'MergeThreshold', 16);
bboxes = step(mouthDetector, FACE);

if size(bboxes, 1) < 1
    M = NaN;
    bboxMouth = NaN;
    return;
end

bboxMouth = bboxes(1, :);
M = imcrop(FACE, bboxMouth);

end

