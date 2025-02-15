clc;
clear;
close all;

% Select video file
[videoFile, videoPath] = uigetfile({'*.mp4;*.avi;*.mov'}, 'Select a video file');
videoPath = fullfile(videoPath, videoFile);
videoObject = VideoReader(videoPath);

% Define frame indices to process
frame1Index = 1; 
frame2Index = 80; 

% Read frames from the video
frame1 = read(videoObject, frame1Index);
frame2 = read(videoObject, frame2Index);

% Detect license plate and center from both frames
[plateCenter1, licensePlate1] = detect_plate_from_frame(frame1);
[plateCenter2, licensePlate2] = detect_plate_from_frame(frame2);

% Recognize license plate characters using OCR
ocrResults = ocr(licensePlate1, 'Language', 'persian');  % Perform OCR on the license plate
recognizedText = ocrResults.Text;  % Extract the recognized text

% Clean up the recognized text
recognizedText = strtrim(recognizedText);  % Remove extra spaces and newlines

% Save the detected license plate text (پلاک) in a text file
fileID = fopen('detected_plate.txt', 'wt');
fprintf(fileID, 'Detected License Plate (پلاک): %s\n', recognizedText);

% Add the speed calculation logic as before
distanceInPixels = sqrt((plateCenter2(1) - plateCenter1(1))^2 + (plateCenter2(2) - plateCenter1(2))^2);
timeBetweenFrames = (frame2Index - frame1Index) / videoObject.FrameRate;
speedInPixelsPerSecond = distanceInPixels / timeBetweenFrames;
pixelToMeterConversion = 0.01;  % Example conversion factor
speedInMetersPerSecond = speedInPixelsPerSecond * pixelToMeterConversion;
speedInKilometersPerHour = speedInMetersPerSecond * 3.6;

% Write the speed information to the text file
fprintf(fileID, 'Car speed in km/h: %.2f\n', speedInKilometersPerHour);

% Close the text file
fclose(fileID);

% Display the result in MATLAB
disp(['Detected License Plate: ', recognizedText]);
disp(['Car speed in km/h: ', num2str(speedInKilometersPerHour)]);

% Cross-platform file opening
if ispc
    winopen('detected_plate.txt');
elseif ismac
    system('open detected_plate.txt');
elseif isunix
    system('xdg-open detected_plate.txt');
else
    disp('Could not automatically open the file.');
end

% Save the license plate images from both frames
imwrite(licensePlate1, 'frame1_with_plate.png');
imwrite(licensePlate2, 'frame2_with_plate.png');

disp('License plates detected and saved successfully.');

% Function to detect license plate from frame and return its center and the cropped image
function [plateCenter, licensePlate] = detect_plate_from_frame(img)
    % Apply median filtering to reduce noise
    imgFiltered = zeros(size(img), 'like', img);
    for c = 1:size(img, 3)
        imgFiltered(:,:,c) = medfilt2(img(:,:,c), [3 3]);
    end

    % Resize image for easier processing
    imgFiltered = imresize(imgFiltered, [400, NaN]);

    % Adjust contrast
    adjustedImg = imadjust(imgFiltered, stretchlim(imgFiltered), []);

    % Convert to HSV to better detect color
    hsvImage = rgb2hsv(adjustedImg);

    % Define thresholds for blue color detection (adjust for your specific dataset)
    blueHueMin = 0.58;
    blueHueMax = 0.75;
    blueSatMin = 0.4;
    blueValMin = 0.2;

    % Create binary mask to isolate blue regions (potential license plates)
    binaryImg = (hsvImage(:,:,1) >= blueHueMin) & (hsvImage(:,:,1) <= blueHueMax) & ...
                (hsvImage(:,:,2) >= blueSatMin) & ...
                (hsvImage(:,:,3) >= blueValMin);

    % Clean up the binary image
    binaryImg = imclose(binaryImg, strel('rectangle', [2, 2]));
    binaryImg = imfill(binaryImg, 'holes');
    binaryImg = bwareaopen(binaryImg, 20);  % Remove small areas

    % Label connected components in the binary image
    [labeledImg, num] = bwlabel(binaryImg);

    % Find the largest connected component (likely the license plate)
    maxArea = 0;
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
            blueEdges = [minCol, minRow, blueWidth, blueHeight];
        end
    end

    if isempty(blueEdges)
        error('No significant blue region found.');
    end

    % Calculate the bounding box and center of the detected plate
    plateX = round(blueEdges(1));
    plateY = round(blueEdges(2));
    plateWidth = blueEdges(3);
    plateHeight = blueEdges(4);

    plateCenterX = plateX + round(plateWidth / 2);
    plateCenterY = plateY + round(plateHeight / 2);
    plateCenter = [plateCenterX, plateCenterY];

    % Crop the license plate area from the original image
    imageHeight = size(imgFiltered, 1);
    imageWidth = size(imgFiltered, 2);

    plateRightX = plateX + round(plateWidth * 11);
    plateX = max(1, plateX - 10);  
    plateY = max(1, plateY - 10);
    plateRightX = min(imageWidth, plateRightX + 10);  
    plateHeight = min(imageHeight - plateY + 1, plateHeight + 20); 

    licensePlate = imgFiltered(plateY:(plateY + plateHeight - 1), plateX:plateRightX, :);

    % Display the filtered image with the detected license plate area marked
    figure, imshow(imgFiltered);
    hold on;
    plot(plateCenterX, plateCenterY, 'r+', 'MarkerSize', 10, 'LineWidth', 2);
    rectangle('Position', [plateX, plateY, plateRightX - plateX, plateHeight], 'EdgeColor', 'g', 'LineWidth', 2);
    hold off;
    title('Detected License Plate with Center Point');
end
