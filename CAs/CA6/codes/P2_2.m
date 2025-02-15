fs = 8000;

note_duration = 0.5;

C4 = 261.63;
D4 = 293.66;
E4 = 329.63;
F4 = 349.23;
G4 = 392.00;
A4 = 440.00;

melody = [C4, C4, G4, G4, A4, A4, G4, ...
          F4, F4, E4, E4, D4, D4, C4, ...
          G4, G4, F4, F4, E4, E4, D4, ...
          G4, G4, F4, F4, E4, E4, D4, ...
          C4, C4, G4, G4, A4, A4, G4, ...
          F4, F4, E4, E4, D4, D4, C4];

t = 0:1/fs:note_duration-1/fs;

music = [];

for i = 1:length(melody)
    note = sin(2 * pi * melody(i) * t);
    music = [music, note];
end

music = music / max(abs(music));

filename = 'twinkle_twinkle_full.wav';
audiowrite(filename, music, fs);

sound(music, fs);

info = audioinfo(filename);
disp(['Sample Rate: ', num2str(info.SampleRate), ' Hz']);
disp(['Total Samples: ', num2str(info.TotalSamples)]);
disp(['Duration (seconds): ', num2str(info.Duration)]);
disp(['Bits per Sample: ', num2str(info.BitsPerSample)]);

