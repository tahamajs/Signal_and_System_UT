clc;           
clear;        
close all;  

di=dir('English_mapset');
st={di.name};
nam=st(3:end);
len=length(nam);


TRAIN=cell(2,len);
for i=1:len
   TRAIN(1,i)={imread(['English_map_set','\',cell2mat(nam(i))])};
   temp=cell2mat(nam(i));
   TRAIN(2,i)={temp(1)};
end

save('TRAININGSET.mat','TRAIN');
clear;
