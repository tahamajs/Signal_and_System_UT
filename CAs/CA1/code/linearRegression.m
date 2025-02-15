function [alpha, beta] = linearRegression(x, y)
    n = length(x);
    
    sum_x = sum(x);
    sum_y = sum(y);
    sum_xy = sum(x .* y);
    sum_x_squared = sum(x .^ 2);
    
    alpha = (n * sum_xy - sum_x * sum_y) / (n * sum_x_squared - sum_x^2);
    beta = (sum_y * sum_x_squared - sum_x * sum_xy) / (n * sum_x_squared - sum_x^2);
end
