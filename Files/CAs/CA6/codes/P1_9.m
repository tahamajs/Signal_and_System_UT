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

N = length(y_total); 
y_fft = fftshift(fft(y_total)); 
f = (-fs/2):(fs/N):(fs/2 - fs/N); 
magnitude = abs(y_fft) / max(abs(y_fft));

[peaks, locations] = findpeaks(magnitude, 'MinPeakHeight', 0.1); % Identify peaks in the spectrum
num_objects = length(peaks); % Estimate the number of objects

estimated_R = R;
estimated_V = zeros(1, num_objects);
for i = 1:num_objects
    doppler_shift = f(locations(i));
    estimated_V(i) = doppler_shift * R / fc;
end

disp(['Estimated R: ', num2str(estimated_R), ' m']);
for i = 1:num_objects
    disp(['Estimated V', num2str(i), ': ', num2str(estimated_V(i)), ' m/s']);
end

figure;
plot(t, y_total, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Combined Received Signal in Time Domain');
grid on;

figure;
plot(f, magnitude, 'LineWidth', 1.5);
hold on;
plot(f(locations), peaks, 'r*', 'MarkerSize', 10);
hold off;
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Magnitude Spectrum with Detected Peaks');
grid on;

figure;
theta = angle(y_fft); 
plot(f, theta/pi, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Phase / \pi');
title('Phase Spectrum of Combined Signal');
grid on;

disp(['Detected number of objects: ', num2str(num_objects)]);
disp('Fourier Transform (Magnitude and Phase) plots with object detection are completed.');
