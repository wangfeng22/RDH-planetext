clear
clc 
%I = imread('测试图像/Lena.tiff'); %读入图像；s=7/s=10
 I = imread('测试图像/Baboon.tiff'); % s=39/s=空
% I = imread('测试图像/Airplane (F-16).tiff'); % s=4/s=5
% I = imread('测试图像/Peppers.tiff'); % s=10/s=15
% I = imread('测试图像/Sailboat on lake.tiff'); % s=11/s=24
% I = imread('测试图像/Fishing boat.tiff'); % s=12/s=21
origin_I = double(I);
%% 产生二进制秘密数据
% e = 0.1; %嵌入率/BPP
% num = floor(512*512*e); % 10000/20000
num = 10000;
% for i=1:100 %取100组不同数据
i=1;
rand('seed',i); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 设置参数，控制嵌入量
s = 39;
%% 数据嵌入
[emD,num_emD,stego_I] = Embedding(D,origin_I,s);
% p = psnr(origin_I,stego_I);
% PSNR(i) = p;
% if num_emD<num
%     error = 0 %判断循环中数据嵌入量有无错误
% end
% end
% PSNR_sum=0;
% for x=1:100
%     PSNR_sum = PSNR_sum + PSNR(x);
% end
% origin = PSNR_sum/100 %100组数据的平均PSNR
% PSNR(101) = origin;
%% 数据提取和恢复
[exD,recover_I] = Extract(stego_I,s,num);
%% 图像对比
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(stego_I,[]);title('载密图像');
subplot(224);imshow(recover_I,[]);title('恢复图像');
%% 判断结果是否正确
psnrvalue = psnr(origin_I,stego_I)
isequal(emD,exD)
isequal(origin_I,recover_I)
