clc;
close all;
clear;

[file, path] = uigetfile('*.jpg;*.png;*.jpeg;*.bmp');
picture = imread([path, file]);
picture = rgb2gray(picture);
imshow(picture);
threshold =  graythresh(picture);
picture = ~imbinarize(picture, threshold - 0.2);
imshow(picture);
imshow(picture);
picture = bwareaopen(picture, 60000);
imshow(picture);
imshow(picture);
background = bwareaopen(picture, 4400000);
imshow(background);
picture =  picture - background;
imshow(picture);
imshow(picture);
[L,Ne]=bwlabel(picture);
propied=regionprops(L,'BoundingBox');

for n=1:size(propied,1)
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end

for n=1:Ne
    [r,c] = find(L==n);
    Y=picture(min(r):max(r),min(c):max(c));
    imshow(Y)
    pathStr = sprintf('Farsi_mapset\\%d.bmp', n);
    imwrite(Y, pathStr);
end
