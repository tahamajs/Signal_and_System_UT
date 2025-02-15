% تعریف متغیرهای سمبولیک
syms y(t)

% تعریف معادله دیفرانسیل
Dy = diff(y, t);
D2y = diff(y, t, 2);
eqn = D2y + 3*Dy + 2*y == 5*heaviside(t);

% تعریف شرایط اولیه
conds = [y(0) == 1, Dy(0) == 1];

% حل معادله دیفرانسیل
ySol(t) = dsolve(eqn, conds);

% نمایش پاسخ
disp('پاسخ معادله دیفرانسیل:');
pretty(ySol)

% رسم پاسخ
fplot(ySol, [0, 10]);
title('پاسخ معادله دیفرانسیل');
xlabel('زمان (ثانیه)');
ylabel('y(t)');
grid on;

% تعریف تابع دیفرانسیل مرتبه دوم به سیستم معادلات مرتبه اول
function dydt = odeSystem(t, y)
    % y(1) = y(t)
    % y(2) = dy/dt
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = 5*heaviside(t) - 3*y(2) - 2*y(1);
end

tspan = [0 10];

% شرایط اولیه
y0 = [1; 1];

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
