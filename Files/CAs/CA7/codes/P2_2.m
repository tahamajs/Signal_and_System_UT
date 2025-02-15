% پارامترها
M = 1;       % جرم اتومبیل (kg)
K = 1;       % سختی فنر (N/m)
B = 10;      % ضریب میرایی (Ns/m)

% تعریف تابع تبدیل H(s) = (1 + B s) / (s^2 + B s + 1)
numerator = [B, 1];
denominator = [1, B, 1];
H = tf(numerator, denominator);

% تعریف زمان شبیه‌سازی
t = 0:0.001:10; % از 0 تا 10 ثانیه با گام 0.001 ثانیه

% تعریف ورودی سیگنال پله‌ای
u = ones(size(t)); % سیگنال پله واحد

% محاسبه پاسخ سیستم به ورودی پله
[y, t] = step(H, t);

% رسم پاسخ سیستم
figure;
plot(t, y, 'LineWidth', 2);
title('پاسخ پله سیستم تعلیق اتومبیل');
xlabel('زمان (ثانیه)');
ylabel('جابجایی کابین y(t) (m)');
grid on;

% تغییر مقدار B و بررسی تاثیر آن
B_values = [0, 0.1, 10, 100]; % مقادیر مختلف B

figure;
for i = 1:length(B_values)
    B = B_values(i);
    numerator = [B, 1];
    denominator = [1, B, 1];
    H = tf(numerator, denominator);
    [y, t] = step(H, t);
    subplot(length(B_values), 1, i);
    plot(t, y, 'LineWidth', 2);
    title(['پاسخ پله سیستم برای B = ', num2str(B), ' Ns/m']);
    xlabel('زمان (ثانیه)');
    ylabel('جابجایی کابین y(t) (m)');
    grid on;
end

% کد مقایسه پاسخ عددی و نظری
% تعریف تابع دیفرانسیل مرتبه دوم به سیستم معادلات مرتبه اول
function dydt = odeSystem(t, y)
    % y(1) = y(t)
    % y(2) = dy/dt
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = 5*heaviside(t) - 3*y(2) - 2*y(1);
end

% بازه زمانی شبیه‌سازی
tspan = [0 10];

% شرایط اولیه
y0 = [1; 1];

% حل عددی معادله با استفاده از ode45
[t_num, y_num] = ode45(@odeSystem, tspan, y0);

% محاسبه پاسخ نظری
y_theoretical = 2*exp(-3*t_num) - 2*exp(-t_num);

% رسم پاسخ عددی و نظری
figure;
plot(t_num, y_num(:,1), 'b-', 'LineWidth', 2); hold on;
plot(t_num, y_theoretical, 'r--', 'LineWidth', 2);
title('مقایسه پاسخ عددی و نظری');
xlabel('زمان (ثانیه)');
ylabel('y(t)');
legend('پاسخ عددی', 'پاسخ نظری');
grid on;
hold off;
