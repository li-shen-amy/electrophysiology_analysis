function [gosi, gdsi] = get_gosi_gdsi(r)
r(r<0)=0;
theta = 0:pi/6:11*pi/6;

Z_ori = r.*exp(theta*2*1i);
B_ori = sum(Z_ori)/sum(r);
gosi = abs(B_ori);

Z_dir = r.*exp(theta*1i);
B_dir = sum(Z_dir)/sum(r);
gdsi = abs(B_dir);

end