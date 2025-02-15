% no noise
load p2.mat

[a,b] = p2_4(x,y);

disp(['a = ', num2str(a)]); % change the number to str
disp(['b = ', num2str(b)]);

%with noise

noise=0.1*randn(1,length(x)); % normal samples with std = 0.1 and len(x)

% "a" value is multiplied by all elements of vector "x", same as "b"
new_y = a * x + b + noise; 

plot(x,new_y,'.')
grid on