[x,fs]=audioread('x.wav');
new_x = p4_3(x,0.5);
display([length(new_x),length(x)]);
new_x = p4_3(x,2);
display([length(new_x),length(x)]);
new_x = p4_3(x,2.5);
display([length(new_x),length(x)]);
