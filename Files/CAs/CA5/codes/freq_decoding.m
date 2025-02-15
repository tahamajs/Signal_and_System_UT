function decoded_message = freq_decoding(signal, bit_rate)
    fs = 100; 
    T = 1 / bit_rate; 
    freq_map = [12, 37]; 
    num_samples = T * fs; 
    
    num_symbols = length(signal) / num_samples;
    binary_message = '';
    for i = 1:num_symbols
        segment = signal((i-1)*num_samples+1:i*num_samples);
        fft_segment = abs(fft(segment));
        [~, max_idx] = max(fft_segment); 
        freq_detected = (max_idx - 1) * fs / length(segment); 
        
        if abs(freq_detected - freq_map(1)) < abs(freq_detected - freq_map(2))
            binary_message = strcat(binary_message, '0');
        else
            binary_message = strcat(binary_message, '1');
        end
    end
    
    global Mapset;
    decoded_message = '';
    for i = 1:5:length(binary_message)
        bin_segment = binary_message(i:i+4);
        idx = find(strcmp(Mapset(2, :), bin_segment));
        decoded_message = strcat(decoded_message, Mapset{1, idx});
    end
end

