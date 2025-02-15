function [a, b] = p2_4(x, y)
    sum_xy = sum(x .* y); % element wise mult istead of vector mult
    sum_xx = sum(x .^ 2);
    sum_y = sum(y);
    sum_x = sum(x);
    
    sum_power_2 = sum_x^2;
    n = length(x); 

    % The formula is: a = (n * Σ(xy) - Σ(x) * Σ(y)) / (n * Σ(x^2) - (Σ(x))^2)
    a = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_power_2);


    % The formula is: b = (Σ(y) * Σ(x^2) - Σ(x) * Σ(xy)) / (n * Σ(x^2) - (Σ(x))^2)
    b = (sum_y * sum_xx - sum_x * sum_xy) / (n * sum_xx - sum_power_2);

end
