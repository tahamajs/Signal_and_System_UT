function new_x = p4_4(x, s)
    % Error handling
    if mod(s, 0.1) ~= 0 || s < 0
        error('The value of s must be a positive multiple of 0.1');
    end

    fs = 48000;  % Assuming this won't change
    p = 10;
    q = 10 * s; % int needed
    new_x = resample(x,p,q); % resampling by the needed factor of 1/s
    sound(new_x, fs);
end
