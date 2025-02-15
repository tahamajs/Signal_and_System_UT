% پاسخ نظری
I_theoretical = 2*exp(-3*t) - 2*exp(-t);

% رسم پاسخ نظری به همراه پاسخ MATLAB
figure;
plot(t, y, 'b', 'LineWidth', 2); hold on;
plot(t, I_theoretical, 'r--', 'LineWidth', 2);
title('مقایسه پاسخ پله سیستم RLC');
xlabel('زمان (ثانیه)');
ylabel('جریان I(t) (آمپر)');
legend('پاسخ MATLAB', 'پاسخ نظری');
grid on;
hold off;
