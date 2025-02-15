fs = 100; 
Ts = 1/fs; 
t_start = 0; 
t_end = 1; 
t = t_start:Ts:t_end-Ts; 

x2 = cos(30 * pi * t + pi/4);

figure;
plot(t, x2, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal in Time Domain: x2(t) = cos(30πt + π/4)');
grid on;

N = length(x2); 
y = fftshift(fft(x2)); 
f = (-fs/2):(fs/N):(fs/2 - fs/N); 

magnitude = abs(y) / max(abs(y));

figure;
plot(f, magnitude, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Magnitude Spectrum of x2(t)');
grid on;

tol = 1e-6; 
y(abs(y) < tol) = 0; 
theta = angle(y); 

figure;
plot(f, theta/pi, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase / \pi');
title('Phase Spectrum of x2(t)');
grid on;

disp('Fourier Transform (Magnitude and Phase) plots are completed.');
