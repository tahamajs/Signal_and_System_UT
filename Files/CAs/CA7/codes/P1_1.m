% پارامترها
R = 1;
L = 0.25;
C = 4/3;

numerator = [1 0];
denominator = [L, R, 1/C]; 
sys = tf(numerator, denominator);

t = 0:0.001:10;

[y, t] = step(sys, t);

figure;
plot(t, y, 'LineWidth', 2);
title('پاسخ پله سیستم RLC');
xlabel('زمان (ثانیه)');
ylabel('جریان I(t) (آمپر)');
grid on;
