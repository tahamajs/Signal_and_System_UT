fs = 100; 
Ts = 1/fs; 
t_start = 0;
t_end = 1;
t = t_start:Ts:t_end-Ts; 

alpha = 0.5;
fc = 5;
fd = 0.3;
td = 0.2; 
noise_power = 0.02;

phi_new = 2 * pi * fc * t + 2 * pi * fd * (t - td);
noise = sqrt(noise_power) * randn(size(t));
y = alpha * cos(phi_new) + noise;

figure;
plot(t, y, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Received Signal with Noise in Time Domain');
grid on;

N = length(y); 
y_fft = fftshift(fft(y)); 
f = (-fs/2):(fs/N):(fs/2 - fs/N); 

magnitude = abs(y_fft) / max(abs(y_fft));

figure;
plot(f, magnitude, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Magnitude Spectrum of y(t) with Noise');
grid on;

tol = 1e-6; 
y_fft(abs(y_fft) < tol) = 0; 
theta = angle(y_fft); 

figure;
plot(f, theta/pi, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase / \pi');
title('Phase Spectrum of y(t) with Noise');
grid on;

disp('Fourier Transform (Magnitude and Phase) plots with Noise are completed.');
