global Mapset;
characters = ['a':'z', ' ', '.', ',', '!', ';'];
binary_values = dec2bin(0:length(characters)-1, 5);
Mapset = cell(2, length(characters));
Mapset(1, :) = num2cell(characters);
Mapset(2, :) = cellstr(binary_values);

message = 'hello!';
bit_rates = [1, 5]; 
max_variances = zeros(1, length(bit_rates));

for br_idx = 1:length(bit_rates)
    br = bit_rates(br_idx);
    disp(['Testing for bit rate: ', num2str(br), ' bits/s']);
    
    encoded_signal = freq_coding(message, br);
    
    tolerance_reached = false;
    variance = 0.0001; 
    while ~tolerance_reached
        noisy_signal = encoded_signal + sqrt(variance) * randn(size(encoded_signal));
        
        decoded_message = freq_decoding(noisy_signal, br);
        
        if ~strcmp(decoded_message, message)
            tolerance_reached = true;
            max_variances(br_idx) = variance; 
            disp(['Decoding failed at variance: ', num2str(variance)]);
        else
            variance = variance + 0.0001; 
        end
    end
end

disp('Maximum tolerable noise variances:');
for br_idx = 1:length(bit_rates)
    disp(['Bit rate: ', num2str(bit_rates(br_idx)), ' bits/s, Max Variance: ', num2str(max_variances(br_idx))]);
end
