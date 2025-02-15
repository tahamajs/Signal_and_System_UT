ts = 1e-9;
T = 1e-5;
tau = 1e-6;
start_time = 0;
c = 3e8;
R = 450;
alpha = 0.5;

td = 2 * R / c;
pulse_idx = td / ts;

Total_samples = round(T/ts); 
pulse_samples = round(tau/ts);

signal = zeros(1, Total_samples);
pulse = alpha * ones(1, pulse_samples);


signal(pulse_idx:pulse_idx + pulse_samples - 1) = signal(pulse_idx:pulse_idx + pulse_samples - 1) + pulse;

time = start_time:ts:T - ts;

plot(time, signal, 'LineWidth', 4);
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal with Pulse');
grid on;
