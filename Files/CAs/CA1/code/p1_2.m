t = 0:0.01:1;
z1 = sin(2*pi*t);
z2 = cos(2*pi*t);

figure;

subplot(1, 2, 1);
plot(t, z1, '--b');
title('Sin');
xlabel('time');
ylabel('amplitude');
text(0.5, 0, 'sin(2 \pi t)');
legend('sin');
grid on;

subplot(1, 2, 2);
plot(t, z2, 'r');
title('Cos');
xlabel('time');
ylabel('amplitude');
text(0.5, 0, 'cos(2 \pi t)');
legend('cos');
grid on;
