clear all; close all; clc;

I = imread('../images/candidates/11.jpg');

templatePath = '../images/mean.jpg';
T = imread(templatePath);
T = T(35:140, 30:100);

t = imresize(T, [59 40]);

minMeanDiff = 10000000;
means = [];
found = [];
for scaleX = 0.9:0.1:1.1
    scaledX = imresize(t, [size(t, 1)*scaleX size(t, 2)]);
    for scaleY = 0.9:0.1:1.1
        scaledY = imresize(scaledX, [size(scaledX,1) size(scaledX,2)*scaleY]);
        for theta = -10:2.5:10
            rotated = imrotate(scaledY, theta);
            for x = 1:2:(size(I, 1) - size(rotated, 1))
                for y = 1:2:(size(I, 2) - size(rotated, 2))
                    resizedTemplate = uint8(zeros(size(I, 1), size(I, 2)));
                    resizedTemplate(x:x + size(rotated, 1) - 1, y:y + size(rotated, 2) - 1) = rotated;
                    tdiff = imabsdiff(I, resizedTemplate);

%                     imshow(tdiff);pause(0.001);
                    meanDiff = mean(tdiff(:));
                    means = [means meanDiff];
                    if meanDiff < minMeanDiff
                        minMeanDiff = meanDiff;
                        found = tdiff;
                        fscaleX = scaleX;
                        fscaleY = scaleY;
                        ftheta = theta;
                        fx = x;
                        fy = y;
                    end
                end
            end
        end
    end
end

imshow(found);

closeMatches = find(means > floor(minMeanDiff) & means < ceil(minMeanDiff));

if(size(closeMatches) < 50)
    title('probably a face');
else
    title('probably not face');
end




