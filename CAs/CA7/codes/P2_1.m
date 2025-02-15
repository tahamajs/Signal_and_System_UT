% پارامترها
M = 1;
K = 1;
B_values = [0, 0.1, 10, 100]; 

t = 0:0.001:10; 

figure;
for i = 1:length(B_values)
    B = B_values(i);
    numerator = [B, 1]; 
    denominator = [1, B, 1];
    sys = tf(numerator, denominator); 
    [y, t] = impulse(sys, t); 
    subplot(length(B_values),1,i); 
    plot(t, y);
    title(['پاسخ ضربه سیستم برای B = ', num2str(B)]);
    xlabel('زمان (ثانیه)');
    ylabel('جابجایی کابین');
    grid on;
end
