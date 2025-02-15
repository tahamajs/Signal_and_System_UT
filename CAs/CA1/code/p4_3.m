function new_x = p4_3(x, s)
    if s == 0.5
        new_x = zeros(1, 2 * length(x));
        new_x(1:2:length(new_x)) = x;
        for i = 2:2:length(new_x)
            if i ~= length(new_x) 
                new_x(i) = (new_x(i - 1) + new_x(i + 1)) / 2;
            end
        end
    elseif s == 2
        new_x = zeros(1, round(0.5 * length(x)));
        new_x = x(1:2:length(x));
    else
        error('only 2 or 0.5 is accepted for speed')
    end
    
    fs = 48000;
    sound(new_x, fs)
end



