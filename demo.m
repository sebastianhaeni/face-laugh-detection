clear all; clear clc; close all;

addpath('lib');

cam = webcam;

while true
    preview(cam);
    pause;
    closePreview(cam);
    I = snapshot(cam);
    imshow(I);
    
    [F, bboxFace] = face(I);
    if isnan(F)
        title('Keiner da');
        continue;
    end
    
    rectangle('Position', bboxFace, 'EdgeColor', 'cyan');
    text(bboxFace(1, 1) + 10, bboxFace(1, 2) + 10, 'Gesicht', 'Color', 'cyan');
    
    [M, bboxMouth] = mouth(F);
    if isnan(M)
        title('Kein Mund sichtbar');
        continue;
    end
    
    bboxMouth(1) = bboxMouth(1) + bboxFace(1);
    bboxMouth(2) = bboxMouth(2) + bboxFace(2);
    rectangle('Position', bboxMouth, 'EdgeColor', 'cyan');
    text(bboxMouth(1, 1) + 10, bboxMouth(1, 2) + 10, 'Mund', 'Color', 'cyan');
    
    S = smile(M);

    if S > 0.5 
        title('Sie sehen gl?cklich aus.');
    elseif S > 0.4
       title('Ihre Stimmung scheint zu schwanken.');
    else
        title('Sie sehen nicht sehr gl?cklich aus.');
    end
    
    pause(.3);
end