ts = 1e-9;
T = 1e-5;
tau = 1e-6;
start_time = 0;
alpha = 0.5;
max_noise_mult = 300;
max_iter = 100;
base_noise_std = 0.01;
true_R = 450;

pulse_idx = 3000; %from the last section
Total_samples = round(T/ts); % fp operation may fail to return int
pulse_samples = round(tau/ts); % fp operation may fail to return int

signal = zeros(1,Total_samples); 
pulse = alpha * ones(1,pulse_samples); % pulse amp is reduced

% Here the pulse must start from td 
signal(pulse_idx:pulse_idx+pulse_samples - 1) = ...
signal(pulse_idx:pulse_idx+pulse_samples - 1) + pulse; % -1 is due to len mismatch

noise_loss = zeros(1,max_noise_mult);
for noise_mult = 1:max_noise_mult
    loss_vector = zeros(1,max_iter); % a vector of 100 loss values
    for test_num = 1:max_iter % for 100 iterations
        noise = noise_mult * base_noise_std * randn(1,Total_samples);
        noisy_signal = signal + noise; % updating signal with noise
        
        %computing correlation and estimated R
        final_corr = zeros(1,Total_samples - pulse_samples);
        
        for i=1:Total_samples - pulse_samples
            final_corr(i) = dot(noisy_signal(i:i+pulse_samples - 1), pulse);
        end
        
        [val,index] = max(final_corr);
        td = index * ts;
        c = 3e8;
        R = td * c / 2;
        
        % loss of R
        loss_vector(test_num) = abs(true_R - R);
    end
    
    noise_loss(noise_mult) = mean(loss_vector);
end

noise_mult_vec = base_noise_std:base_noise_std:max_noise_mult * base_noise_std;

plot(noise_mult_vec, noise_loss, 'LineWidth', 2);
xlabel('nosie std');
ylabel('mean loss');
title('loss and noise std');
grid on;
