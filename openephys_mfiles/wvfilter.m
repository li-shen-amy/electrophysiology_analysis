% wavelet filter
function fdata = wvfilter(data)

[C, L] = wavedec(data, 6, 'db4');
C(1:L(1)) = 0;
fdata = waverec(C, L, 'db4');
end
