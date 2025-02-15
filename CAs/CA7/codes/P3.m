% تعریف متغیرها
syms y(t) x(t)
Dy = diff(y, t);
D2y = diff(y, t, 2);

eqn = D2y + 3*Dy + 2*y == 5*heaviside(t);

conds = [y(0) == 1, Dy(0) == 1];

% حل معادله دیفرانسیل
ySol(t) = dsolve(eqn, conds);

% نمایش پاسخ
disp('پاسخ سیستم y(t):');
pretty(ySol)

% تبدیل پاسخ به تابع قابل محاسبه
yFunc = matlabFunction(ySol);

% تعریف بازه زمانی
t_vals = linspace(0, 10, 1000);

% محاسبه مقادیر y(t)
y_vals = yFunc(t_vals);

% رسم نمودار پاسخ
figure;
plot(t_vals, y_vals, 'LineWidth', 2);
xlabel('زمان (ثانیه)');
ylabel('y(t)');
title('پاسخ سیستم از t = 0 تا t = 10 ثانیه');
grid on;

% مقایسه با پاسخ تحلیلی
% پاسخ تحلیلی از بخش (الف):
% y(t) = (5/2) - 2*exp(-t) + 0.5*exp(-2*t)

% محاسبه پاسخ تحلیلی
y_analytic = (5/2) - 2*exp(-t_vals) + 0.5*exp(-2*t_vals);

% رسم مقایسه
figure;
plot(t_vals, y_vals, 'b', 'LineWidth', 2); hold on;
plot(t_vals, y_analytic, 'r--', 'LineWidth', 2);
xlabel('زمان (ثانیه)');
ylabel('y(t)');
title('مقایسه پاسخ MATLAB با پاسخ تحلیلی');
legend('پاسخ MATLAB', 'پاسخ تحلیلی');
grid on;
