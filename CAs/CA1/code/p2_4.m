load p2.mat
t=-1:0.01:1;
[alpha, beta] = linearRegression(x,y);
plot(t,(t*alpha+beta),'LineWidth',4);

 hold on ;
plot(x,y);
fprintf('Alpha: %.4f\n', alpha);
fprintf('Beta: %.4f\n', beta);