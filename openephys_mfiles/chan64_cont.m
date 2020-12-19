% cont data openephys2bin
idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');
dat1 = zeros(64, length(data));

for i = 1:64
    fn = ['100_CH', num2str(idx(i)), '.continuous'];
    [data, timestamps, info] = load_open_ephys_data(fn);
    fdata = ffilter(data);  
    dat1(i,:) = fdata';
end

maxdata = max(abs(dat1(:)));
factor = 32767/maxdata;
dat2 = int16(dat1*factor); % 16 bit

fid = fopen('2018-03-28_18-43-18-300-6000.bin','w','l');
fwrite(fid, dat2, 'int16','l');
fclose(fid);

lcar = cell(64, 1);
for i = 1:64
    lcar{i} = [1,2,8,9]+(i-5);
    lcar{i}(lcar{i}<1 | lcar{i}>64)=[];
end

d_lcar = dat1;
for i = 1:64
    lc_idx = lcar{i};
    lc = mean(dat1(lc_idx,:),1);
    d_lcar(i,:) = dat1(i,:)-lc;
end

gcar = mean(dat1,1);
d_gcar = dat1 - repmat(gcar, 64, 1);

maxdata = max(abs(d_lcar(:)));
factor = 32767/maxdata;
d2_lcar = int16(d_lcar*factor); % 16 bit

fid = fopen('2018-03-21_15-48-13-lcar.bin','w','l');
fwrite(fid, d2_lcar, 'int16','l');
fclose(fid);

maxdata = max(abs(d_gcar(:)));
factor = 32767/maxdata;
d2_gcar = int16(d_gcar*factor); % 16 bit

fid = fopen('2018-03-21_15-48-13-gcar.bin','w','l');
fwrite(fid, d2_gcar, 'int16','l');
fclose(fid);