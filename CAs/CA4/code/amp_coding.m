function [coded_signal, t] = amp_coding(message, bit_rate)
    fs = 100;                 
    Tb = 1;                   
    samples_per_bit = fs * Tb; 
    message = lower(message); 
    
    bits_per_character = 6; 
    
    characters = ['a':'z', ' ', '.', ',', '!', ';', '"'];
    Mapset = cell(32, 2);
    for i = 1:length(characters)
        Mapset{i, 1} = characters(i);
        Mapset{i, 2} = dec2bin(i-1, bits_per_character);
    end
    
    binary_message = '';
    for i = 1:length(message)
        idx = find(characters == message(i));
        if isempty(idx)
            error('کاراکتر "%c" معتبر نیست.', message(i));
        end
        binary_message = [binary_message, Mapset{idx, 2}];
    end
    
    bits_per_symbol = bit_rate;
    num_symbols = length(binary_message) / bits_per_symbol;
    if rem(length(binary_message), bits_per_symbol) ~= 0
        error('طول رشته باینری با نرخ ارسال مطابقت ندارد.');
    end
    
    symbols = reshape(binary_message, bits_per_symbol, num_symbols)';
    
    coded_signal = [];
    t = [];
    for i = 1:num_symbols
        symbol_bits = symbols(i, :);
        symbol_decimal = bin2dec(symbol_bits);
        amplitude = symbol_decimal / (2^bits_per_symbol - 1);
        time = (i-1)*Tb*bits_per_symbol : 1/fs : i*Tb*bits_per_symbol - 1/fs;
        signal = amplitude * sin((pi*(time - (i-1)*Tb*bits_per_symbol))/2);
        coded_signal = [coded_signal, signal];
        t = [t, time];
    end
end