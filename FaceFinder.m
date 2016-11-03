function FaceFinder()
    clear all; close all; clc;

    fullImageFileName = 'images/group3/09.JPG';

    rgbImage = imread(fullImageFileName);
    rgbImage = imresize(rgbImage, .3);
    bwImage = rgb2gray(rgbImage);
    
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

%     imshow(hueMask,[]);pause;
%     imshow(valueMask,[]);pause;

    coloredObjectsMask = uint8(hueMask & valueMask);
    coloredObjectsMask = uint8(bwareaopen(coloredObjectsMask, 3000));

    structuringElement = strel('disk', morphFactor);
    coloredObjectsMask = imclose(coloredObjectsMask, structuringElement);

%     imshow(coloredObjectsMask,[]);pause;

    structuringElement = strel('disk', double(int8(morphFactor * 1.5)));
    coloredObjectsMask = imerode(coloredObjectsMask, structuringElement);
   
%     imshow(coloredObjectsMask,[]);pause;
 
    coloredObjectsMask = imdilate(coloredObjectsMask, structuringElement);

%     imshow(coloredObjectsMask, []);pause;

    [boundaries, labels] = bwboundaries(coloredObjectsMask, 'noholes');

    templatePath = 'images/mean.jpg';
    T = imread(templatePath);
    T = T(35:140, 30:100);
    templateRatio = size(T,1)/size(T,2);
    
    stats = regionprops(labels, 'Area', 'Centroid');
    threshold = 0.80;

    imshow(rgbImage);
    hold on

    for k = 1:size(boundaries)
        boundary = boundaries{k};
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)

        % compute a simple estimate of the object's perimeter
        delta_sq = diff(boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq,2)));

        % obtain the area calculation corresponding to label 'k'
        area = stats(k).Area;

        % compute the roundness metric
        metric = 4*pi*area/perimeter^2;

        % display the results
%         metric_string = sprintf('%2.2f',metric);
%            text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
%               'FontSize',14,'FontWeight','bold');

        % mark objects above the threshold with a black circle
        if metric > threshold
            centroid = stats(k).Centroid;
            plot(centroid(1),centroid(2),'ko');
            
            x1 = min(boundary(:,1));
            x2 = max(boundary(:,1));
            y1 = min(boundary(:,2));
            y2 = max(boundary(:,2));
            width = x2 - x1;
            height = y2 - y1;
            
            ratio = width / height;
            ratio_string = sprintf('%2.5f', ratio);
            text(boundary(1,2)-35,boundary(1,1)+33,ratio_string,'Color','y',...
                'FontSize',14,'FontWeight','bold');
            
            if ratio >= 1.2 && ratio < 1.8
                width = width + (morphFactor*1.5);
                height = width / templateRatio;
                t = imresize(T, [width height]);
%                 t = histeq(t);
%                 break;
            end
        end
    end
    
    hold off;
%     pause;
    figure;
    
    for k = 1:size(boundaries)
        boundary = boundaries{k};
        
        x1 = min(boundary(:,1));
        x2 = max(boundary(:,1));
        y1 = min(boundary(:,2));
        y2 = max(boundary(:,2));
        
        faceCandidate = bwImage((x1-morphFactor):(x2+morphFactor), (y1-morphFactor):(y2+morphFactor));
%         faceCandidate = bwImage((x1+(morphFactor/3)):(x2-(morphFactor/3)), (y1+(morphFactor/3)):(y2-(morphFactor/3)));
%         faceCandidate = bwImage(x1:x2, y1:y2);
        faceCandidate = imgaussfilt(faceCandidate, 3);
        imwrite(faceCandidate, sprintf('images/candidates/%d.jpg', k));
        
        found = [];
        minMeanDiff = 10000000;
        for scaleX = 0.8:0.05:1.1
            scaledX = imresize(t, [size(t, 1)*scaleX size(t, 2)]);
            for scaleY = 0.8:0.05:1.1
                scaledY = imresize(scaledX, [size(scaledX,1) size(scaledX,2)*scaleY]);
                for theta = -15:2.5:15
                    rotated = imrotate(scaledY, theta);
                    for x = 1:10:(size(faceCandidate, 1) - size(rotated, 1))
                        for y = 1:10:(size(faceCandidate, 2) - size(rotated, 2))
                            resizedTemplate = uint8(zeros(size(faceCandidate, 1), size(faceCandidate, 2)));
                            resizedTemplate(x:x + size(rotated, 1) -1, y:y + size(rotated, 2) - 1) = rotated;
                            tdiff = imabsdiff(faceCandidate, resizedTemplate);

                            meanDiff = mean(tdiff(:));
                            if meanDiff < minMeanDiff
                                minMeanDiff = meanDiff;
                                found = tdiff;
                            end
                        end
                    end
                end
            end
        end

        %         meanDiffString = sprintf('%2.2f %2.fx%2.f/%2.1f, %2.1/%2.1f', ...
%             minMeanDiff, fx, fy, fscaleX, fscaleY, ftheta);
%         text(boundary(1,2)-35,boundary(1,1)+33,meanDiffString,'Color','y',...
%             'FontSize',14,'FontWeight','bold');
        
        subplot(2,7,k);
        %imshow(faceCandidate(fx:size(t, 1)*fscaleX, fy:size(t, 2)*fscaleY));
        imshow(found, []);        
        title(sprintf('%2.2f', minMeanDiff));
%         title(meanDiffString, 'FontSize', 8);
        
        pause(0.1);
        
%         for x = 1:size(faceCandidate,1)
%             for y = 1:size(faceCandidate,2)
%                 
%             end
%         end
        
%         faceCandidate = histeq(faceCandidate);
%         figure;
%         imshow(faceCandidate);
        
%         hold on;
%         matchTemplate(t, faceCandidate);
%         hold off;
    end
    
%     imshow(t);
    
    return;
    matchTemplate(t, bwImage);
    
    function matchTemplate(template, greyImage)

        C = normxcorr2(template, greyImage);
        imshow(template);
        % Mark positions with high correlation
        [rows, cols] = find(C > 0.5);
      
        ps = size(template,1)/2;
        for y = cols
            for x = rows
                plot(y-ps, x-ps, 'x', 'LineWidth', 3, 'Color', 'yellow');
            end
        end
    end

end