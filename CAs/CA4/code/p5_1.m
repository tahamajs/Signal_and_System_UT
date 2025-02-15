noise = randn(1, 3000);

figure;
histogram(noise, 50);
title('هیستوگرام نویز تولید شده با randn');

mean_noise = mean(noise);
fprintf('میانگین نویز: %f\n', mean_noise);

var_noise = var(noise);
fprintf('واریانس نویز: %f\n', var_noise);
