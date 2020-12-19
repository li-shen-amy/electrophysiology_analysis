% fft of original data
Fs = 30000;
T = 1/Fs;
L = length(f1);
t = (0:L-1)*T;

X = f1(1:L);
Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f, P1);