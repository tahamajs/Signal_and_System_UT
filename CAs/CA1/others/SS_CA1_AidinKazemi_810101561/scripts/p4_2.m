[x,fs] = audioread('poem.wav');
time_step = 1 / fs;

time_vec_len = length(x);
time = time_step:time_step:time_vec_len * time_step;

plot(time, x, 'LineWidth', 2);
xlabel('time');
ylabel('x');
title('sound and time');
grid on;

sound(x,fs)
audiowrite('x.wav',x,fs);