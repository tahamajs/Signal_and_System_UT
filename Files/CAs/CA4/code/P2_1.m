fs = 8000; 
T_standard = 0.5; 

not = [4,4,1,2,4,4,3,3,4,2,4,3,4,3,2,3,4,3,3,4,2,4,3,4,3,4,2,3,4,3,4,2,3,4,4,3,2,3,2,2,3,2,2,4];
is_half = [1,1,2,2,2,1,1,1,1,1,1,1,2,2,2,2,2,1,1,1,1,1,2,2,1,1,2,2,2,1,2,1,2,2,2,1,1,2,2,2,1,1,2,2,1,1,2,1,1,2,1,1,2,2,2];
note_mapping = containers.Map([1, 2, 3, 4], [261.63, 293.66, 329.63, 392.00]);
frequencies = zeros(1, length(not));
for i = 1:length(not)
    frequencies(i) = note_mapping(not(i));
end
music = [];
for i = 1:length(frequencies)
    if is_half(i) == 1
        t_duration = T_standard / 2; 
    else
        t_duration = T_standard; 
    end
    
    t_note = 0:1/fs:t_duration-1/fs;
    
    note = sin(2 * pi * frequencies(i) * t_note);
    
    music = [music, note];
end

music = music / max(abs(music));
filename = 'mysong.wav';
audiowrite(filename, music, fs);
disp('Audio saved as mysong.wav.');
player = audioplayer(music, fs);
disp('Playing the song...');
playblocking(player);
info = audioinfo(filename);
disp(['Sample Rate: ', num2str(info.SampleRate), ' Hz']);
disp(['Total Samples: ', num2str(info.TotalSamples)]);
disp(['Duration (seconds): ', num2str(info.Duration)]);
disp(['Bits per Sample: ', num2str(info.BitsPerSample)]);
