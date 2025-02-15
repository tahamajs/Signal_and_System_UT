t= -1:0.001:1;


alpha = 3;
beta = 2;


y = t*alpha + beta + rand(size(t));


plot(t,y);

hold on;


[alpha_t,beta_t] = linearRegression(t,y);

x = -1:0.001:1;

plot(x, x*alpha_t +beta_t, 'LineWidth',3);
 