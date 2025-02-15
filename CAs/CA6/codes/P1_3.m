fs = 100; 
Ts = 1/fs; 
t_start = 0;
t_end = 1;
t = t_start:Ts:t_end-Ts; 

alpha = 0.5;
fc = 5;
fd = 0.3;
td = 0.2; 

phi_new = 2 * pi * fc * t + 2 * pi * fd * (t - td);
y = alpha * cos(phi_new);

figure;
plot(t, y, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Received Signal in Time Domain');
grid on;

N = length(y); 
y_fft = fftshift(fft(y)); 
f = (-fs/2):(fs/N):(fs/2 - fs/N); 

magnitude = abs(y_fft) / max(abs(y_fft));

figure;
plot(f, magnitude, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Magnitude Spectrum of y(t)');
grid on;

tol = 1e-6; 
y_fft(abs(y_fft) < tol) = 0; 
theta = angle(y_fft); 

figure;
plot(f, theta/pi, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase / \pi');
title('Phase Spectrum of y(t)');
grid on;

disp('Fourier Transform (Magnitude and Phase) plots are completed.');
