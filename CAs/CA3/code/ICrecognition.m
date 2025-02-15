function ICrecognition(IC_image_path, PCB_image_path, threshold)
    IC_image = imread(IC_image_path);
    PCB_image = imread(PCB_image_path);
    
    if size(IC_image, 3) == 3
        IC_image = rgb2gray(IC_image);
    end
    if size(PCB_image, 3) == 3
        PCB_image = rgb2gray(PCB_image);
    end
    
    correlation_map = normxcorr2(IC_image, PCB_image);
    
    [ypeaks, xpeaks] = find(correlation_map >= threshold);
    
    [IC_height, IC_width] = size(IC_image);
    
    figure;
    imshow(PCB_image);
    title('Matching Result');
    hold on;
    
    for i = 1:length(xpeaks)
        x = xpeaks(i) - IC_width;
        y = ypeaks(i) - IC_height;
        rectangle('Position', [x, y, IC_width, IC_height], 'EdgeColor', 'r', 'LineWidth', 2);
    end
    
    hold off;
end

