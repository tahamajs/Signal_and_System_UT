[x,fs] = audioread("sample.wav");

 
fprintf("Frequency : %d \n", fs);


time_step = 1/fs;


time_vector_len = length(x);

time = time_step :time_step:time_vector_len *time_step;
plot(time,x);


fprintf("Time Step : %d \n", time_step);

sound(x, fs);

audiowrite('x.wav',x,fs);