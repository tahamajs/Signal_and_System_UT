%%
clc;
clear;
close all;

%2-1
tstart=-1;
tend=1;
fs=50;
ts=1/fs;

t=tstart:ts:tend-ts;
N=length(t);
x6=dirac(t)>0;
subplot(2, 1, 1)
plot(t, x6)
xlabel 't'
ylabel 'x(t)'

subplot(2, 1, 2)
freq=-fs/2:fs/N:fs/2-fs/N;
x6f=fftshift(fft(x6));
z6f=abs(x6f)/max(abs(x6f));
plot(freq, z6f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'
%%
clc;
clear;
close all;

%2-2
tstart=-1;
tend=1;
fs=50;
ts=1/fs;

t=tstart:ts:tend-ts;
N=length(t);
x7=ones(1, N);
subplot(2, 1, 1)
plot(t, x7)
xlabel 't'
ylabel 'x(t)'

subplot(2, 1, 2)
freq=-fs/2:fs/N:fs/2-fs/N;
x7f=fftshift(fft(x7));
z7f=abs(x7f)/max(abs(x7f));
plot(freq, z7f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'