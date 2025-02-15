ts = 1e-9;
T = 1e-5;
tau = 1e-6;
start_time = 0;

Total_samples = round(T/ts);
pulse_samples = round(tau/ts);

signal = zeros(1, Total_samples);
pulse = ones(1, pulse_samples);

signal(1:pulse_samples) = signal(1:pulse_samples) + pulse;

time = start_time:ts:T - ts; 

plot(time, signal, 'LineWidth', 4);
xlabel('Time (s)');
ylabel('Amplitude');
title('Signal with Pulse');
grid on;
