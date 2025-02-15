fs = 100; 
Ts = 1/fs; 
t_start = -1;
t_end = 1;
t = t_start:Ts:t_end-Ts;

x1 = cos(10 * pi * t);

figure;
plot(t, x1, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal in Time Domain: x1(t) = cos(10πt)');
grid on;

N = length(x1);
y = fftshift(fft(x1));
f = (-fs/2):(fs/N):(fs/2 - fs/N); 

magnitude = abs(y) / max(abs(y));

figure;
plot(f, magnitude, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Magnitude Spectrum of x1(t)');
grid on;

disp('Fourier Transform and plots are completed successfully.');
