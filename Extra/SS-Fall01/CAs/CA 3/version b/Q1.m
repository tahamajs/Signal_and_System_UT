clc;
clear;
close all;

%0-1
tstart=0;
tend=1;
fs=20;
ts=1/fs;

t=tstart:ts:tend-ts;
N=length(t);
x1=exp(1j*2*pi*5*t) + exp(1j*2*pi*8*t);
x2=exp(1j*2*pi*5*t) + exp(1j*2*pi*5.1*t);

subplot(4, 1, 1)
freq1=0:fs/N:(N-1)*fs/N;
x1f=fft(x1);
z1f=abs(x1f)/max(abs(x1f));
plot(freq1, z1f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'

subplot(4, 1, 2)
freq2=-fs/2:fs/N:fs/2-fs/N;
x2f=fftshift(x1f);
z2f=abs(x2f)/max(abs(x2f));
plot(freq2, z2f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'

subplot(4, 1, 3)
x3f=fft(x2);
z3f=abs(x3f)/max(abs(x3f));
plot(freq1, z3f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'

subplot(4, 1, 4)
x4f=fftshift(x3f);
z4f=abs(x4f)/max(abs(x4f));
plot(freq2, z4f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'
%%
clc;
clear;
close all;

%1-1
tstart=-1;
tend=1;
fs=50;
ts=1/fs;

t=tstart:ts:tend-ts;
N=length(t);
x1=cos(2*pi*5*t);

subplot(2, 1, 1)
plot(t, x1)
xlabel 't'
ylabel 'x(t)'

subplot(2, 1, 2)
freq=-fs/2:fs/N:fs/2-fs/N;
x1f=fftshift(fft(x1));
z1f=abs(x1f)/max(abs(x1f));
plot(freq, z1f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'
%%
clc;
clear;
close all;

%1-2
tstart=-1;
tend=1;
fs=50;
ts=1/fs;

t=tstart:ts:tend-ts;
N=length(t);
x2=rectangularPulse(-1/2, 1/2, t);
subplot(2, 1, 1)
plot(t, x2)
xlabel 't'
ylabel 'x(t)'

subplot(2, 1, 2)
freq=-fs/2:fs/N:fs/2-fs/N;
x2f=fftshift(fft(x2));
z2f=abs(x2f)/max(abs(x2f));
plot(freq, z2f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'
%%
clc;
clear;
close all;

%1-3
tstart=-1;
tend=1;
fs=50;
ts=1/fs;

t=tstart:ts:tend-ts;
N=length(t);
x3=cos(2*pi*5*t).*rectangularPulse(-1/2, 1/2, t);
subplot(2, 1, 1)
plot(t, x3)
xlabel 't'
ylabel 'x(t)'

subplot(2, 1, 2)
freq=-fs/2:fs/N:fs/2-fs/N;
x3f=fftshift(fft(x3));
z3f=abs(x3f)/max(abs(x3f));
plot(freq, z3f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'
%%
clc;
clear;
close all;

%1-4
tstart=0;
tend=1;
fs=100;
ts=1/fs;

t=tstart:ts:tend-ts;
N=length(t);
freq=-fs/2:fs/N:fs/2-fs/N;
x4=cos(2*pi*15*t+pi/4);
x4f=fftshift(fft(x4));
z4f=abs(x4f)/max(abs(x4f));
subplot(2, 1, 1)
plot(freq, z4f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'

subplot(2, 1, 2)
tol=6;
x4f(abs(x4f)<tol)=0;
theta=angle(x4f);
plot(freq, theta/pi)
xlabel 'Frequency(Hz)'
ylabel 'Phase/\pi'

%%
clc;
clear;
close all;

%1-5
tstart=-19;
tend=19;
fs=50;
ts=1/fs;
n=9;
t=tstart:ts:tend-ts;
N=length(t);

tmpx5=0;

for k=-n:n
    tmpx5=tmpx5+rectpuls(t-2*k);
end

x5=tmpx5;
subplot(2, 1, 1)
plot(t, x5)
xlabel 't'
ylabel 'x(t)'

subplot(2, 1, 2)
freq=-fs/2:fs/N:fs/2-fs/N;
x5f=fftshift(fft(x5));
z5f=abs(x5f)/max(abs(x5f));
plot(freq, z5f)
xlabel 'Frequency'
ylabel 'Size Of Fourier Transform'