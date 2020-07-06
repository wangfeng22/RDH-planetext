clc
clear
I=imread('Lena.tiff');%读取图像
origin_I=double(I);
pixelnum=200000;
data=randi([0,1],1,pixelnum);%随机产生秘密数据
[stego_I,emD,emD_num]=embed(origin_I,data);
[recover_I,exD,exD_num]=extract(stego_I,pixelnum);
t=isequal(emD,exD);
m=isequal(origin_I,recover_I);
figure(1);
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(stego_I,[]);title('载密图像');
subplot(223);imshow(recover_I,[]);title('恢复后的图像');

