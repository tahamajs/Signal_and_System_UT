function [plateCenter, licensePlate] = detect_plate_from_frame(img)
    imgFiltered = zeros(size(img), 'like', img);
    for c = 1:size(img, 3)
        imgFiltered(:,:,c) = medfilt2(img(:,:,c), [3 3]);
    end

    imgFiltered = imresize(imgFiltered, [400, NaN]);

    adjustedImg = imadjust(imgFiltered, stretchlim(imgFiltered), []);

    hsvImage = rgb2hsv(adjustedImg);

    blueHueMin = 0.58;
    blueHueMax = 0.75;
    blueSatMin = 0.4;
    blueValMin = 0.2;

    binaryImg = (hsvImage(:,:,1) >= blueHueMin) & (hsvImage(:,:,1) <= blueHueMax) & ...
                (hsvImage(:,:,2) >= blueSatMin) & ...
                (hsvImage(:,:,3) >= blueValMin);
    
    binaryImg = imclose(binaryImg, strel('rectangle', [2, 2]));
    binaryImg = imfill(binaryImg, 'holes');
    binaryImg = bwareaopen(binaryImg, 20); 

    [labeledImg, num] = bwlabel(binaryImg);

    maxArea = 0;
    blueRegionIdx = 0;
    blueEdges = [];

    for k = 1:num
        [rows, cols] = find(labeledImg == k);
        if isempty(rows) || isempty(cols)
            continue;
        end
        
        minRow = min(rows);
        maxRow = max(rows);
        minCol = min(cols);
        maxCol = max(cols);

        blueWidth = maxCol - minCol + 1;
        blueHeight = maxRow - minRow + 1;

        area = length(rows);
        if area > maxArea
            maxArea = area;
            blueRegionIdx = k;
            blueEdges = [minCol, minRow, blueWidth, blueHeight];
        end
    end

    if isempty(blueEdges)
        error('No significant blue region found.');
    end

    plateX = round(blueEdges(1));
    plateY = round(blueEdges(2));
    plateWidth = blueEdges(3);
    plateHeight = blueEdges(4);

    plateCenterX = plateX + round(plateWidth / 2);
    plateCenterY = plateY + round(plateHeight / 2);
    plateCenter = [plateCenterX, plateCenterY];

    imageHeight = size(imgFiltered, 1);
    imageWidth = size(imgFiltered, 2);
    
    plateRightX = plateX + round(plateWidth * 11);
    plateX = max(1, plateX - 10);  
    plateY = max(1, plateY - 10);
    plateRightX = min(imageWidth, plateRightX + 10);  
    plateHeight = min(imageHeight - plateY + 1, plateHeight + 20); 

    licensePlate = imgFiltered(plateY:(plateY + plateHeight - 1), plateX:plateRightX, :);
    
    figure, imshow(imgFiltered);
    hold on;
    plot(plateCenterX, plateCenterY, 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    rectangle('Position', [plateX, plateY, plateRightX - plateX, plateHeight], 'EdgeColor', 'g', 'LineWidth', 2);
    hold off;
    title('Detected License Plate with Center Point');
end
