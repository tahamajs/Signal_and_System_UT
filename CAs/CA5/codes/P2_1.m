characters = ['a':'z', ' ', '.', ',', '!', ';'];
binary_values = dec2bin(0:length(characters)-1, 5); 

Mapset = cell(2, length(characters));
Mapset(1, :) = num2cell(characters);
Mapset(2, :) = cellstr(binary_values);

disp('Character Mapset:');
disp(Mapset);




global Mapset;

message = 'hello!';
bit_rate = 2; 

encoded_signal = freq_coding(message, bit_rate);


decoded_message = freq_decoding(encoded_signal, bit_rate);

disp(['Original Message: ', message]);
disp(['Decoded Message: ', decoded_message]);
