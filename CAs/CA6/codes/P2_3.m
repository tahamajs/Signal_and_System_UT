[music_loaded, fs_loaded] = audioread('CHIHIRO.mp3');

disp(['Sample Rate: ', num2str(fs_loaded), ' Hz']);
disp(['Total Samples: ', num2str(length(music_loaded))]);
disp(['Duration (seconds): ', num2str(length(music_loaded) / fs_loaded)]);

t_loaded = (0:length(music_loaded)-1) / fs_loaded;

figure;
plot(t_loaded, music_loaded);
xlabel('Time (s)');
ylabel('Amplitude');
title('Waveform of Loaded Music');
grid on;

threshold = 0.01; 
above_threshold = abs(music_loaded) > threshold; 
changes = find(diff(above_threshold));
durations = diff(changes) / fs_loaded; 

disp('Extracted Note Durations (seconds):');
disp(durations);

segment_duration = 0.5; 
N_segment = round(segment_duration * fs_loaded); 
frequencies = []; 

for i = 1:N_segment:length(music_loaded)-N_segment
    segment = music_loaded(i:i+N_segment-1); 
    Y_fft = fft(segment); 
    [~, idx] = max(abs(Y_fft)); 
    f = (idx-1) * fs_loaded / length(Y_fft); 
    frequencies = [frequencies, f]; 
end

disp('Extracted Frequencies (Hz):');
disp(frequencies);

fs_output = 8000;
t_note = 0:1/fs_output:segment_duration-1/fs_output; 
synthetic_music = []; 

for f = frequencies
    note = sin(2 * pi * f * t_note); 
    synthetic_music = [synthetic_music, note]; 
end

synthetic_music = synthetic_music / max(abs(synthetic_music));

output_filename = 'extracted_music.wav';
audiowrite(output_filename, synthetic_music, fs_output);

sound(synthetic_music, fs_output);

info = audioinfo(output_filename);
disp(['Output File Sample Rate: ', num2str(info.SampleRate), ' Hz']);
disp(['Output File Total Samples: ', num2str(info.TotalSamples)]);
disp(['Output File Duration (seconds): ', num2str(info.Duration)]);
disp(['Output File Bits per Sample: ', num2str(info.BitsPerSample)]);
