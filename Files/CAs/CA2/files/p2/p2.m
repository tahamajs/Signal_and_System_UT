files = dir('persian_dataset');

len = length(files) - 2;

TRAIN = cell(2, len);

for i = 1:len
TRAIN{1, i} = imread(fullfile(files(i + 2).folder, files(i + 2).name));
    TRAIN{2, i} = files(i + 2).name(1);
end

function grayImg = mygrayfun(colorImg)
    redChannel = colorImg(:,:,1);
    greenChannel = colorImg(:,:,2);
    blueChannel = colorImg(:,:,3);
    
    grayImg = 0.299 * redChannel + 0.578 * greenChannel + 0.114 * blueChannel;
end




function binaryImage = mybinaryfun(grayImage, threshold)
    binaryImage = grayImage > threshold;  
    binaryImage = ~binaryImage;
end


threshold = 128; 

for i = 1:size(TRAIN, 2)
    rgbImage = TRAIN{1, i};
    grayImage = mygrayfun(rgbImage);
    binaryImage = mybinaryfun(grayImage, threshold);
    TRAIN{1, i} = binaryImage;
end




for i = 1:size(TRAIN, 2)
    binaryImage = TRAIN{1, i};

    [rows, cols] = find(binaryImage == 1);

    if isempty(rows) || isempty(cols)
        croppedImage = binaryImage;  
    else
        minRow = min(rows);
        maxRow = max(rows);
        minCol = min(cols);
        maxCol = max(cols);

        croppedImage = binaryImage(minRow:maxRow, minCol:maxCol);
    end

    resizedImage = imresize(croppedImage, [150 150]);

    TRAIN{1, i} = resizedImage;
end

save TRAININGSET TRAIN;

