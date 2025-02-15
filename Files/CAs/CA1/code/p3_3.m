ts = 1e-9;
T = 1e-5;
tau = 1e-6;
start_time = 0;
alpha = 0.5;

pulse_idx = 3000;
Total_samples = round(T/ts); 
pulse_samples = round(tau/ts); 


fprintf("%d \n",Total_samples );
fprintf("%d \n",pulse_samples );


signal = zeros(1, Total_samples);
pulse = alpha * ones(1, pulse_samples);



signal(pulse_idx:pulse_idx + pulse_samples - 1) = signal(pulse_idx:pulse_idx + pulse_samples - 1) + pulse;

final_corr = zeros(1, Total_samples - pulse_samples);




for i = 1:Total_samples - pulse_samples
    final_corr(i) = dot(signal(i:i + pulse_samples - 1), pulse);
end





time = start_time:ts:T - ts * (pulse_samples + 1);

plot(time, final_corr, 'LineWidth', 4);
xlabel('Time (s)');
ylabel('Correlation');
title('Correlation and Time');
grid on;



[value,index] = max(final_corr);
td = index*ts;
c=3e8;
R = td*c/2;
fprintf("%d \n", R);