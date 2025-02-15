fs = 100; 
Ts = 1/fs; 
t_start = 0;
t_end = 1;
t = t_start:Ts:t_end-Ts;

alpha = 0.5;
beta = 0.3;
R = 250;
V = 180 * 1000 / 3600; 
fc = 5;

x2 = cos(2 * pi * (fc * t + beta * (V/R) * sin(2 * pi * alpha * t)));

figure;
plot(t, x2, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal in Time Domain');
grid on;

N = length(x2); 
y = fftshift(fft(x2)); 
f = (-fs/2):(fs/N):(fs/2 - fs/N); 

magnitude = abs(y) / max(abs(y));

figure;
plot(f, magnitude, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Magnitude Spectrum');
grid on;

theta = angle(y); 

figure;
plot(f, theta/pi, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase / π');
title('Phase Spectrum');
grid on;
