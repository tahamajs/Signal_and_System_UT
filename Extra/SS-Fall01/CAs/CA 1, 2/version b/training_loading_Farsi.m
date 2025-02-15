clc;
close all;
clear;

mapset_dir = dir('Farsi_mapset\');
col_name = {mapset_dir.name};
target_name = col_name(3:end);
target_len = length(target_name);

data_table = cell(2, target_len);
for i = 1:target_len
    data_table(1, i) = {imresize(imread(['Farsi_mapset\', target_name{i}]), [NaN, 64])};
    data_table(2, i) = {extractBefore(target_name{i}, ".")};
end

save('Farsi_DATA_TABLE.mat', "data_table");
clear;
