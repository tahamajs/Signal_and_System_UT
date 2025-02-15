function new_x = p4_4(x, s)
    if mod(s, 0.1) ~= 0 || s < 0
        error('The value of s must be a positive multiple of 0.1');
    end
    
    fs = 48000;
    p = 10;
    q = 10 * s;
    new_x = resample(x, p, q);
    sound(new_x, fs);
end
