

[x, fs] = audioread('x.wav');

new_x = p4_3(x, 0.5);
fprintf('Case 1: Speed factor 0.5\n');
fprintf('Length of new_x: %d, Length of original x: %d\n\n', length(new_x), length(x));

new_x = p4_3(x, 2);
fprintf('Case 2: Speed factor 2\n');
fprintf('Length of new_x: %d, Length of original x: %d\n\n', length(new_x), length(x));

new_x = p4_3(x, 2.5);
fprintf('Case 3: Speed factor 2.5\n');
fprintf('Length of new_x: %d, Length of original x: %d\n\n', length(new_x), length(x));




[x, fs] = audioread('x.wav');

new_x = p4_4(x', 0.4);
fprintf('Speed factor: 0.4 - New length: %d, Original length: %d\n', length(new_x), length(x));

new_x = p4_4(x', 2.3);
fprintf('Speed factor: 2.3 - New length: %d, Original length: %d\n', length(new_x), length(x));

new_x = p4_4(x', 1.77);
fprintf('Speed factor: 1.77 - New length: %d, Original length: %d\n', length(new_x), length(x));




