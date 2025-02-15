% Get a list of all files in the "Map Set" directory
files = dir('Map Set');

% Calculate the number of valid files (not '.' and '..')
len = length(files) - 2;

% Initialize a cell array to store training data
TRAIN = cell(2, len);

% Loop through each file in the directory, starting from the third file
for i = 1:len
    % Read the image from the file and store it in the first row of the TRAIN cell array
    TRAIN{1, i} = imread([files(i + 2).folder, filesep, files(i + 2).name]);

    % Extract the first character of the file name (its label)
    % and store it in the second row of the TRAIN cell array
    TRAIN{2, i} = files(i + 2).name(1);
end

% Save the TRAIN cell array to a file named "TRAININGSET.mat"
save TRAININGSET TRAIN;




%% Step 1: Load an image file
[file, path] = uigetfile({'*.jpg;*.png;*.jpeg', 'Choose an image file'});

% Create the full file path and load the selected image
img = imread(fullfile(path, file));

% Display the image in a new figure window
figure, imshow(img);





function grayImg = mygrayfun(colorImg)
    redChannel = colorImg(:,:,1);
    greenChannel = colorImg(:,:,2);
    blueChannel = colorImg(:,:,3);
    
    grayImg = 0.299 * redChannel + 0.578 * greenChannel + 0.114 * blueChannel;
end

grayImg = mygrayfun(img);
figure, imshow(grayImg);






function binaryImage = mybinaryfun(grayImage, threshold)
    binaryImage = grayImage > threshold;  
    binaryImage = ~binaryImage;
end

threshold = 100;  
binaryImage = mybinaryfun(grayImg, threshold);

figure, imshow(binaryImage);


function [POINTS, newPoints] = close_points(current_point, POINTS)
    neighbors = [
        -1, -1;
        -1,  0;
        -1,  1;
         0, -1;
         0,  1;
         1, -1;
         1,  0;
         1,  1
    ];
    
    newPoints = [];
        for i = 1:size(neighbors, 1)
        new_row = current_point(1) + neighbors(i, 1);
        new_col = current_point(2) + neighbors(i, 2);
        
        idx = find(POINTS(1, :) == new_row & POINTS(2, :) == new_col, 1);
        
        if ~isempty(idx)
            newPoints = [newPoints, [new_row; new_col]];
            POINTS(:, idx) = [];
        end
    end
end



function cleanImage = myremovecom(binaryImage, n_minSize)
    [row, col] = find(binaryImage == 1); 
    POINTS = [row'; col'];  

    if isempty(POINTS)
        cleanImage = binaryImage; 
        return;
    end

    cleanImage = zeros(size(binaryImage));  

    while ~isempty(POINTS)
        initpoint = POINTS(:, 1);  
        POINTS(:, 1) = [];  

        points_to_explore = initpoint;
        currentObject = initpoint;

        while ~isempty(points_to_explore)
            current_point = points_to_explore(:, 1);
            points_to_explore(:, 1) = [];  

            [POINTS, newPoints] = close_points(current_point, POINTS);

            currentObject = [currentObject newPoints];
            points_to_explore = [points_to_explore newPoints];
        end

        if size(currentObject, 2) >= n_minSize
            for j = 1:size(currentObject, 2)
                cleanImage(currentObject(1, j), currentObject(2, j)) = 1;
            end
        end
    end
end



minSize = 300; 
cleanImage = myremovecom(binaryImage, minSize);
figure, imshow(cleanImage);
title('Cleaned Binary Image (Small Components Removed)');




function [labeledImage, numObjects] = mysegmentation(cleanImage)
    [row, col] = find(cleanImage == 1);  
    POINTS = [row'; col'];  

    if isempty(POINTS)
        labeledImage = zeros(size(cleanImage));  
        numObjects = 0;
        return;
    end

    labeledImage = zeros(size(cleanImage));  
    currentLabel = 0;  

    while ~isempty(POINTS)
        currentLabel = currentLabel + 1;

        initpoint = POINTS(:, 1);
        POINTS(:, 1) = [];  

        points_to_explore = initpoint;
        currentObject = initpoint;

        while ~isempty(points_to_explore)
            current_point = points_to_explore(:, 1);
            points_to_explore(:, 1) = [];

            [POINTS, newPoints] = close_points(current_point, POINTS);

            currentObject = [currentObject newPoints];
            points_to_explore = [points_to_explore newPoints];
        end

        for j = 1:size(currentObject, 2)
            labeledImage(currentObject(1, j), currentObject(2, j)) = currentLabel;
        end
    end

    numObjects = currentLabel;
end


[labeledImage, numObjects] = mysegmentation(cleanImage);  % فراخوانی تابع segment بندی
figure, imshow(label2rgb(labeledImage));  % تبدیل برچسب‌ها به رنگ و نمایش تصویر
title(['Segmented Image (', num2str(numObjects), ' Objects)']);  % عنوان تصویر به همراه تعداد اشیاء




load TRAININGSET;
numTemplates = size(TRAIN, 2);

recognizedText = '';

for segmentIndex = 1:numObjects
    [rowIndices, colIndices] = find(labeledImage == segmentIndex); 
    currentSegment = imresize(cleanImage(min(rowIndices):max(rowIndices), min(colIndices):max(colIndices)), [42, 24]);
    ro = zeros(1, numTemplates); 
    for templateIndex = 1:numTemplates
        ro(templateIndex) = corr2(TRAIN{1, templateIndex}, currentSegment);  
    end

    fig = figure;  
    subplot(1, 2, 1); 
    imshow(currentSegment); 
    title(['Segment ', num2str(segmentIndex)]);

    subplot(1, 2, 2); 
    bar(ro);  
    title(['Correlation Scores for Segment ', num2str(segmentIndex)]);
    xlabel('Template Label');
    ylabel('Correlation Score');

    xticks(1:numTemplates);  
    xticklabels(TRAIN(2, :));  

    drawnow;  

    [bestScore, bestMatchIndex] = max(ro); 
    if bestScore > 0.48 
        recognizedText = [recognizedText, TRAIN{2, bestMatchIndex}];  
    end
end



disp(['Detected pelaak: ', recognizedText]);

fileID = fopen('number_Plate.txt', 'wt');
fprintf(fileID, '%s\n', recognizedText);
fclose(fileID);

winopen('number_Plate.txt');




