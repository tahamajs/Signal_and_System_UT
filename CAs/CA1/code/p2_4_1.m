load('p2.mat'); 

costFunction = @(params) sum((y - (params(1) * x + params(2))).^2);

initialParams = [0, 0];

optimalParams = fminsearch(costFunction, initialParams);

alpha = optimalParams(1);
beta = optimalParams(2);
fprintf('Alpha: %.4f\n', alpha);
fprintf('Beta: %.4f\n', beta);
