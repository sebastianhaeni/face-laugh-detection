clear all; clear clc; close all;

addpath('lib');

while true
    I = snapshot(webcam(1));
    F = face(I);
    M = mouth(F);
    S = smile(M);

    imshow(I);

    if S > 0.7 
        title('Sie sehen glücklich aus.');
    elseif S > 0.4
       title('Ihre Stimmung scheint zu schwanken.');
    else
        title('Sie sehen nicht sehr glücklich aus.');
    end
    
    pause(1);
end