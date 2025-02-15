Mapset = cell(32, 2);

characters = ['a':'z', ' ', '.', ',', '!', ';', '"'];

for i = 1:length(characters)
    Mapset{i, 1} = characters(i);     
    Mapset{i, 2} = dec2bin(i-1, 5);     
end

disp('Mapset:');
for i = 1:length(Mapset)
    fprintf('%c : %s\n', Mapset{i,1}, Mapset{i,2});
end
