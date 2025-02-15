fs = 100; 
Ts = 1/fs; 
t_start = 0;
t_end = 1;
t = t_start:Ts:t_end-Ts; 

R = 200 * 1000; 
V1 = 180 * 1000 / 3600; 
V2 = 216 * 1000 / 3600; 
alpha1 = 0.5;
alpha2 = 0.6;

fc = 5;
phi1 = 2 * pi * fc * t + (2 * pi * V1 / R) * t;
phi2 = 2 * pi * fc * t + (2 * pi * V2 / R) * t;

y1 = alpha1 * cos(phi1);
y2 = alpha2 * cos(phi2);
y_total = y1 + y2;

estimated_R = R;
estimated_V1 = (R / (2 * pi * t(end))) * ((phi1(end) - phi1(1)) / t(end));
estimated_V2 = (R / (2 * pi * t(end))) * ((phi2(end) - phi2(1)) / t(end));

disp(['Estimated R: ', num2str(estimated_R), ' m']);
disp(['Estimated V1: ', num2str(estimated_V1), ' m/s']);
disp(['Estimated V2: ', num2str(estimated_V2), ' m/s']);

figure;
plot(t, y_total, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Combined Received Signal in Time Domain');
grid on;

N = length(y_total); 
y_fft = fftshift(fft(y_total)); 
f = (-fs/2):(fs/N):(fs/2 - fs/N); 

magnitude = abs(y_fft) / max(abs(y_fft));

figure;
plot(f, magnitude, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Magnitude Spectrum of Combined Signal');
grid on;

tol = 1e-6; 
y_fft(abs(y_fft) < tol) = 0; 
theta = angle(y_fft); 

figure;
plot(f, theta/pi, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase / \pi');
title('Phase Spectrum of Combined Signal');
grid on;

disp('Fourier Transform (Magnitude and Phase) plots for Combined Signal are completed.');
