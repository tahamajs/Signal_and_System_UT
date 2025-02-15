global Mapset;
characters = ['a':'z', ' ', '.', ',', '!', ';'];
binary_values = dec2bin(0:length(characters)-1, 5);
Mapset = cell(2, length(characters));
Mapset(1, :) = num2cell(characters);
Mapset(2, :) = cellstr(binary_values);

message = 'hello!';
bit_rates = [1, 5 , 10];
variance = 1.0001; 

for br = bit_rates
    disp(['Testing for bit rate: ', num2str(br), ' bits/s']);
    
    encoded_signal = freq_coding(message, br);
    
    noisy_signal = encoded_signal + sqrt(variance) * randn(size(encoded_signal));
    decoded_message = freq_decoding(noisy_signal, br);
    
    disp(['Original Message: ', message]);
    disp(['Decoded Message: ', decoded_message]);
    
    figure;
    plot(noisy_signal, 'LineWidth', 1.5);
    title(['Noisy Signal (Bit Rate: ', num2str(br), ' bits/s)']);
    xlabel('Time (samples)');
    ylabel('Amplitude');
    grid on;
end
