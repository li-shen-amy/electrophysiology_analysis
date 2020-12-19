maxdata = vmax;
factor = 32767/maxdata;
dat2 = int16(dat1*factor); % 16 bit

fid = fopen('2018-06-10_17-24-38-300-6000.bin','w','l');
fwrite(fid, dat2, 'int16','l');
fclose(fid);