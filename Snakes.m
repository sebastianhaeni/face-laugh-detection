function [] = Snakes()
    clear all; close all; clc; %clear matrices, close figures & clear cmd wnd.

    f = figure('Visible', 'off');

    fPos = f.Position;
    pointBtn = uicontrol('Style', 'PushButton', 'String', 'Draw points',...
        'Position', [5 fPos(4)-50 100 50], 'Callback', @drawPoints);
    startBtn = uicontrol('Style', 'PushButton', 'String', 'Start',...
        'Position', [5 fPos(4)-100 100 50], 'Callback', @start);

    points = zeros(2,1)*(0:100);
    currentPoint = 1;
    I = imread('../images/monkey.png'); % Load image
    I = imresize(I, 2);
    imshow(I);

    f.Visible = 'on';
    
    drawingPoints = false;

    function drawPoints(source, event)
        drawingPoints = ~drawingPoints;
        
        %while drawingPoints
            [x, y] = ginput(1);
            points(1, currentPoint) = x;
            points(2, currentPoint) = y;
            currentPoint = currentPoint + 1;
            I = insertShape(I,'Circle',[x y 5], 'Color', 'green');
            imshow(I);
        %end;
    end

    function start(source, event)
        center = zeros(2, 1);
        current = 0;
        for i = points
            if i(1) == 0
                break
            end
            current = current + 1;
            center(1) = center(1) + i(1);
            center(2) = center(2) + i(2);
        end
        center = center ./ current
        I = insertShape(I,'Circle',[center(1) center(2) 5], 'Color', 'red');
        imshow(I);
    end

end