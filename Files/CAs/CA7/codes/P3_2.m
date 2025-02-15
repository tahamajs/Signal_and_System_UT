function dydt = odeSystem(t, y)
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = 5*heaviside(t) - 3*y(2) - 2*y(1);
end

tspan = [0 10];

y0 = [1; 1];

[t, y] = ode45(@odeSystem, tspan, y0);

figure;
plot(t, y(:,1), 'b-', 'LineWidth', 2);
hold on;

y_theoretical = (5/2) - 2*exp(-t) + 0.5*exp(-2*t);

plot(t, y_theoretical, 'r--', 'LineWidth', 2);

title('مقایسه پاسخ عددی و تئوری');
xlabel('زمان (ثانیه)');
ylabel('y(t)');
legend('پاسخ عددی', 'پاسخ تئوری');
grid on;
hold off;
