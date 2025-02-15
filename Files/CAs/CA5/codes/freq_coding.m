function signal = freq_coding(message, bit_rate)
    fs = 100; 
    T = 1 / bit_rate; 
    t = 0:1/fs:T-1/fs; 
    freq_map = [12, 37];
    
    binary_message = '';
    global Mapset;
    for i = 1:length(message)
        idx = find(strcmp(Mapset(1, :), message(i)));
        binary_message = strcat(binary_message, Mapset{2, idx});
    end
    
    signal = [];
    for i = 1:length(binary_message)
        if binary_message(i) == '0'
            freq = freq_map(1);
        else
            freq = freq_map(2);
        end
        signal = [signal, sin(2 * pi * freq * t)]; 
    end
end

