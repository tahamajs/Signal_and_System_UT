clc;
close all;
clear;

[file, path] = uigetfile({'*.jpg;*.png;*.jpeg'}, 'Select an image');
if isequal(file, 0)
    disp('User canceled the file selection.');
    return;
end
imagePath = fullfile(path, file);
img = imread(imagePath);

imgFiltered = zeros(size(img), 'like', img);
for c = 1:size(img, 3)
    imgFiltered(:,:,c) = medfilt2(img(:,:,c), [3 3]);
end

imgFiltered = imresize(imgFiltered, [400, NaN]);
figure, imshow(imgFiltered);
title('Filtered Image');

adjustedImg = imadjust(imgFiltered, stretchlim(imgFiltered), []);
figure, imshow(adjustedImg);
title('Contrast Adjusted Image');

hsvImage = rgb2hsv(adjustedImg);
figure, imshow(hsvImage);
title('HSV Image');

blueHueMin = 0.58;
blueHueMax = 0.75;
blueSatMin = 0.4;
blueValMin = 0.2;

binaryImg = (hsvImage(:,:,1) >= blueHueMin) & (hsvImage(:,:,1) <= blueHueMax) & ...
            (hsvImage(:,:,2) >= blueSatMin) & ...
            (hsvImage(:,:,3) >= blueValMin);
figure, imshow(binaryImg);
title('Binary Mask for Blue Region');

binaryImg = imclose(binaryImg, strel('rectangle', [2, 2]));
binaryImg = imfill(binaryImg, 'holes');
binaryImg = bwareaopen(binaryImg, 20); 

figure, imshow(binaryImg);
title('Cleaned Binary Mask');

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

imageHeight = size(imgFiltered, 1);
imageWidth = size(imgFiltered, 2);



blueWidth = blueEdges(3);
plateWidth = blueWidth * 11; 

plateX = round(blueEdges(1));
plateY = round(blueEdges(2));
plateHeight = round(blueEdges(4));

plateRightX = plateX + round(plateWidth);

plateX = max(1, plateX - 10);  
plateY = max(1, plateY - 10);
plateRightX = min(imageWidth, plateRightX + 10);  
plateHeight = min(imageHeight - plateY + 1, plateHeight + 20); 

licensePlate = imgFiltered(plateY:(plateY + plateHeight - 1), plateX:plateRightX, :);

figure, imshow(licensePlate);
title('Detected Plate');

imwrite(licensePlate, 'detected_plate.png');
disp('Plate detected and saved successfully.');



