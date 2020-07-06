function [m,n,blkm,blkn]=fun_jpg_size(z,a)
%mn图像大小
%blkm,blkn有多少块8*8用于灰度图
b=find(z(a+1,1)==192);
c=a(b,1); %255，标记坐标
m=z((c+5),1)*16*16+z((c+6),1);  %m n为图片的高和宽
n=z((c+7),1)*16*16+z((c+8),1);
blkm=ceil(m/8); blkn=ceil(n/8); %不足8的倍数补齐再分割
end