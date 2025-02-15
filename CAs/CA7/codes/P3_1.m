syms y(t)

Dy = diff(y, t);
D2y = diff(y, t, 2);
eqn = D2y + 3*Dy + 2*y == 5*heaviside(t);

conds = [y(0) == 1, Dy(0) == 1];

ySol(t) = dsolve(eqn, conds);

disp('پاسخ معادله دیفرانسیل:');
pretty(ySol)

fplot(ySol, [0, 10]);
title('پاسخ معادله دیفرانسیل');
xlabel('زمان (ثانیه)');
ylabel('y(t)');
grid on;
