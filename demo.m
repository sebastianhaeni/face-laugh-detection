clear all; clear clc; close all;

addpath('lib');

while true
    I = snapshot(webcam(1));
    imshow(I);
    
    [F, bboxFace] = face(I);
    if isnan(F)
        title('Keiner da');
        continue;
    end
    
    rectangle('Position', bboxFace);
    text(bboxFace(1, 1) + 10, bboxFace(1, 2) + 10, 'Gesicht');

    [M, bboxMouth] = mouth(I);
    if isnan(M)
        title('Kein Mund sichtbar');
        continue;
    end

    rectangle('Position', bboxMouth);
    text(bboxMouth(1, 1) + 10, bboxMouth(1, 2) + 10, 'Mund');
    
    S = smile(M);

    if S > 0.5 
        title('Sie sehen glücklich aus.');
    elseif S > 0.4
       title('Ihre Stimmung scheint zu schwanken.');
    else
        title('Sie sehen nicht sehr glücklich aus.');
    end
    
    pause(.3);
end