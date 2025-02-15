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
[t, y] = ode45(@odeSystem, tspan, y0);

% رسم پاسخ عددی
figure;
plot(t, y(:,1), 'b-', 'LineWidth', 2);
hold on;

% محاسبه پاسخ نظری
y_theoretical = (5/2) - 2*exp(-t) + 0.5*exp(-2*t);

% رسم پاسخ نظری
plot(t, y_theoretical, 'r--', 'LineWidth', 2);

% تنظیمات نمودار
title('مقایسه پاسخ عددی و تئوری');
xlabel('زمان (ثانیه)');
ylabel('y(t)');
legend('پاسخ عددی', 'پاسخ نظری');
grid on;
hold off;
