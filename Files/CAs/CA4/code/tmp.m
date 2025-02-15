% پیام مورد نظر
message = 'signal';

% نرخ‌های ارسال اطلاعات
bit_rates = [1, 2, 3];

for rate = bit_rates
    [coded_signal, t] = amp_coding(message, rate);
    % افزودن نویز با واریانس 0.0001 (می‌توانید این مقدار را تغییر دهید)
    sigma = sqrt(0.0001);
    noise = sigma * randn(size(coded_signal));
    noisy_signal = coded_signal + noise;
    % رمزگشایی سیگنال (بدون نویز و با نویز)
    decoded_message = amp_decoding(coded_signal, rate);
    decoded_message_noisy = amp_decoding(noisy_signal, rate);
    fprintf('نرخ %d بیت بر ثانیه:\n', rate);
    fprintf('پیام رمزگشایی شده بدون نویز: %s\n', decoded_message);
    fprintf('پیام رمزگشایی شده با نویز: %s\n\n', decoded_message_noisy);
end
