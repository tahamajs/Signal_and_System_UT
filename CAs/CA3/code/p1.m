function Mapset = createMapset()
    chars = ['a':'z', ' ', ';', '.'];
    Mapset = cell(32, 2);
    for i = 1:length(chars)
        Mapset{i, 1} = chars(i);
        Mapset{i, 2} = dec2bin(i-1, 5);
    end
end

function encoded_image = coding(message, Mapset, image)
    binary_message = '';
    for i = 1:length(message)
        idx = find(strcmp(Mapset(:,1), message(i)));
        if isempty(idx)
            error('Character "%s" not found in Mapset.', message(i));
        end
        binary_message = [binary_message, Mapset{idx, 2}];
    end

    if size(image, 3) == 3
        image = rgb2gray(image);
    end

    block_size = 5;
    [rows, cols] = size(image);
    num_blocks_row = floor(rows / block_size);
    num_blocks_col = floor(cols / block_size);

    variances = zeros(num_blocks_row, num_blocks_col);
    for i = 1:num_blocks_row
        for j = 1:num_blocks_col
            block = image((i-1)*block_size+1:i*block_size, (j-1)*block_size+1:j*block_size);
            variances(i,j) = var(double(block(:)));
        end
    end

    [~, sorted_indices] = sort(variances(:), 'descend');
    num_bits = length(binary_message);
    selected_blocks = sorted_indices(1:num_bits);

    encoded_image = image;
    for k = 1:num_bits
        idx = selected_blocks(k);
        i = ceil(idx / num_blocks_col);
        j = mod(idx-1, num_blocks_col) + 1;

        pixel_row = (i-1)*block_size + 1;
        pixel_col = (j-1)*block_size + 1;

        pixel_value = encoded_image(pixel_row, pixel_col);
        pixel_binary = dec2bin(pixel_value, 8);
        pixel_binary(end) = binary_message(k);
        encoded_image(pixel_row, pixel_col) = bin2dec(pixel_binary);
    end
end

function decoded_message = decoding(encoded_image, Mapset)
    if size(encoded_image, 3) == 3
        encoded_image = rgb2gray(encoded_image);
    end

    block_size = 5;
    [rows, cols] = size(encoded_image);
    num_blocks_row = floor(rows / block_size);
    num_blocks_col = floor(cols / block_size);

    variances = zeros(num_blocks_row, num_blocks_col);
    for i = 1:num_blocks_row
        for j = 1:num_blocks_col
            block = encoded_image((i-1)*block_size+1:i*block_size, (j-1)*block_size+1:j*block_size);
            variances(i,j) = var(double(block(:)));
        end
    end

    [~, sorted_indices] = sort(variances(:), 'descend');

    num_bits = 30;
    selected_blocks = sorted_indices(1:num_bits);

    extracted_bits = '';
    for k = 1:num_bits
        idx = selected_blocks(k);
        i = ceil(idx / num_blocks_col);
        j = mod(idx-1, num_blocks_col) + 1;

        pixel_row = (i-1)*block_size + 1;
        pixel_col = (j-1)*block_size + 1;

        pixel_value = encoded_image(pixel_row, pixel_col);
        pixel_binary = dec2bin(pixel_value, 8);
        extracted_bits = [extracted_bits, pixel_binary(end)];
    end

    decoded_message = '';
    for i = 1:5:length(extracted_bits)
        bin_char = extracted_bits(i:i+4);
        idx = find(strcmp(Mapset(:,2), bin_char));

        if isempty(idx)
            warning('Binary sequence "%s" not found in Mapset. Stopping decoding.', bin_char);
            break;
        end
        decoded_message = [decoded_message, Mapset{idx, 1}];
    end
end

original_image = imread('PCB.jpg'); 
Mapset = createMapset();
message = 'signal';
encoded_image = coding(message, Mapset, original_image);

figure;
subplot(1, 2, 1);
imshow(original_image);
title('Original Image');

subplot(1, 2, 2);
imshow(encoded_image);
title('Encoded Image');

decoded_message = decoding(encoded_image, Mapset);
disp(['Decoded Message: ', decoded_message]);
