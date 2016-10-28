function detection()
    clear all; close all; clc;

    fullImageFileName = 'images/group1/02.JPG';

    rgbImage = imread(fullImageFileName);
    % rgbImage = imresize(rgbImage, .3);
    [rows, columns, numberOfColorBands] = size(rgbImage); 

    morphFactor = double(int8(columns / 113));

    % Convert RGB image to HSV
    hsvImage = rgb2hsv(rgbImage);
    % Extract out the H, S, and V images individually
    hImage = hsvImage(:,:,1);
    vImage = hsvImage(:,:,2);

    % imshow(hImage);pause;
    % imshow(vImage);pause;

    hueThresholdLow = 0;
    hueThresholdHigh = graythresh(hImage) * .5;
    valueThresholdLow = graythresh(vImage);
    valueThresholdHigh = 1.0;

    hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
    valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);

    % imshow(hueMask,[]);pause;
    % imshow(valueMask,[]);pause;

    coloredObjectsMask = uint8(hueMask & valueMask);
    coloredObjectsMask = uint8(bwareaopen(coloredObjectsMask, 3000));

    structuringElement = strel('disk', morphFactor);
    coloredObjectsMask = imclose(coloredObjectsMask, structuringElement);

    % imshow(coloredObjectsMask,[]);pause;

    structuringElement = strel('disk', morphFactor * 2);
    coloredObjectsMask = imerode(coloredObjectsMask, structuringElement);
    % imshow(coloredObjectsMask,[]);pause;
    coloredObjectsMask = imdilate(coloredObjectsMask, structuringElement);

    % imshow(coloredObjectsMask, []);pause;

    boundaries  = bwboundaries(coloredObjectsMask, 'noholes');
    % imshow(rgbImage);
    % hold on;

    G = rgb2gray(rgbImage);
    % templatePath = 'images/cpvr_faces_160/0000/01.JPG';
    %T = rgb2gray(T);
    templatePath = 'mean.jpg';
    T = imread(templatePath);
    
%     diff = 0:size(boundaries):0;

    for k = 1:size(boundaries)
        b = boundaries{k};
        x1 = min(b(:,1));
        x2 = max(b(:,1));
        y1 = min(b(:,2));
        y2 = max(b(:,2));

        faceCandidate = G((x1-morphFactor):(x2+morphFactor), (y1-morphFactor):(y2+morphFactor));
%         faceCandidate = G(x1:x2, y1:y2);
    %     imshow(faceCandidate);pause;
    %     widths(k) = x2 - x1;
    %     heights(k) = y2 - y1;

        width = (x2-x1)+1;
        height = (y2-y1)+1;
        ratio = width / height;
%         width = width - morphFactor;
        height = width / ratio;
        
        faceCandidate = histeq(faceCandidate);
        
        t = imresize(T, [width height]);
        t = histeq(t);
        
        matchTemplate(t, faceCandidate);
%         diff(k) = immse(t, faceCandidate);
%         subplot(1,11,k);
%         imshow(faceCandidate);
        pause;
    end

%     figure;
%     plot(diff);
    
    function matchTemplate(template, greyImage)

        C = normxcorr2(template, greyImage);

        subplot(1,2,1), imshow(C,[]); title('Correlation coefficients w. normxcorr2');
        
        pos_e99 = C > 0.99; %positions w. CC > 0.99
        pos_e95 = C > 0.95; %positions w. CC > 0.95
        pos_e85 = C > 0.85; %positions w. CC > 0.85
        pos_e75 = C > 0.75; %positions w. CC > 0.75

        % Mark positions with high correlation
        subplot(1,2,2), imshow(greyImage); 
        hold on;
        ps = size(template,1)/2;
        for y=1:size(pos_e99,2)
           for x=1:size(pos_e99,1)
              if pos_e99(x,y)==1
                 plot(y-ps,x-ps,'x','LineWidth',3,'Color','red');
              elseif pos_e95(x,y)==1
                 plot(y-ps,x-ps,'x','LineWidth',3,'Color','green');
              elseif pos_e85(x,y)==1
                 plot(y-ps,x-ps,'x','LineWidth',3,'Color','blue');
              elseif pos_e75(x,y)==1
                 plot(y-ps,x-ps,'x','LineWidth',3,'Color','yellow');
              end
           end
        end
        hold off;
    end

end