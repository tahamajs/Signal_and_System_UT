function decoded_message = amp_decoding(coded_signal, bit_rate)
    fs = 100;             
    Tb = 1;                  
    samples_per_bit = fs * Tb; 
    
    bits_per_character = 6;   
    bits_per_symbol = bit_rate;
    samples_per_symbol = samples_per_bit * bits_per_symbol;
    
    characters = ['a':'z', ' ', '.', ',', '!', ';', '"'];
    Mapset = cell(32, 2);
    for i = 1:length(characters)
        Mapset{i, 1} = characters(i);
        Mapset{i, 2} = dec2bin(i-1, bits_per_character);
    end
    
    num_symbols = length(coded_signal) / samples_per_symbol;
    if rem(length(coded_signal), samples_per_symbol) ~= 0
        error('طول سیگنال کدگذاری شده با تعداد نمونه‌های هر سمبل مطابقت ندارد.');
    end
    decoded_bits = '';
    
    delta_t = 1/fs;
    
    for i = 1:num_symbols
        symbol_signal = coded_signal((i-1)*samples_per_symbol+1 : i*samples_per_symbol);
        time = 0 : delta_t : Tb*bits_per_symbol - delta_t;
        reference_signal = sin((pi*time)/2);
        correlation = delta_t * sum(symbol_signal .* reference_signal);
        max_correlation = 0.5 * bits_per_symbol;
        amplitude_estimate = correlation / max_correlation;
        amplitude_estimate = max(0, min(amplitude_estimate, 1));
        symbol_decimal = round(amplitude_estimate * (2^bits_per_symbol - 1));
        symbol_bits = dec2bin(symbol_decimal, bits_per_symbol);
        decoded_bits = [decoded_bits, symbol_bits];
    end
    
    decoded_message = '';
    for i = 1:bits_per_character:length(decoded_bits)
        if i+bits_per_character-1 > length(decoded_bits)
            break;
        end
        bits = decoded_bits(i:i+bits_per_character-1);
        idx = find(strcmp(Mapset(:,2), bits));
        if isempty(idx)
            decoded_message = [decoded_message, '?'];
        else
            decoded_message = [decoded_message, Mapset{idx,1}];
        end
    end
end
