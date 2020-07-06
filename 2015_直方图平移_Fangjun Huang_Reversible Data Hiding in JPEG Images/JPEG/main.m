clear
clc
addpath(genpath('C:\Users\Administrator\Desktop\项有智-E17201016-JEPG图像中的可逆信息隐藏2\JPEG\jpegtbx'));%调用工具箱
I = imread('Lena.tiff');
for i = 80 %10:10:90 
QF = i;%量化因子
imwrite(I,'Lena.jpg','jpeg','quality',QF); %生成质量因子为80的jpeg图像
%% 解析JPEG文件
origin_jpeg = imread('Lena.jpg');  %读取原始jpeg图像
jpeg_info = jpeg_read('Lena.jpg'); %解析jpeg图像
dct_coef = jpeg_info.coef_arrays{1,1}; %获取dct系数
%% 绘制ac系数直方图
[hist_ac1,num1,num_1] = jpeg_hist(dct_coef);
figure;
bar(hist_ac1(:,1),hist_ac1(:,2),0.1);
title('质量因子为80的jpeg图像的非零ac系数直方图');
num = num1 + num_1;  %最大嵌入量 
rand('seed',0);  %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 数据嵌入
[emD,jpeg_info_stego] = emdding(D,jpeg_info);
jpeg_write(jpeg_info_stego,'stego_Lena.jpg'); %保存载密jpeg图像
stego_jpeg = imread('stego_Lena.jpg'); %读取载密jpeg图像
%% 数据提取
jpeg_info_stego1 = jpeg_read('stego_Lena.jpg');%解析载密jpeg图像
[exD,jpeg_info_recover] = extract(num,jpeg_info_stego1);
jpeg_write(jpeg_info_recover,'recover_Lena.jpg');%保存恢复jpeg图像
recover_jpeg = imread('recover_Lena.jpg');%读取恢复jpeg图像
%% 图像对比
figure;
subplot(221);imshow(I);title('tiff原始图像');
subplot(222);imshow(origin_jpeg);title('jpeg原始图像');
subplot(223);imshow(stego_jpeg);title('jpeg载密图像');
subplot(224);imshow(recover_jpeg);title('jpeg恢复图像');
%% 判断结果是否正确
psnrvalue = psnr(origin_jpeg,stego_jpeg);
isequal(emD,exD)
isequal(origin_jpeg,recover_jpeg)
%% 文件大小增加分析
ori_filesize = imfinfo('Lena.jpg');
steo_filesize = imfinfo('stego_Lena.jpg');
Lena_ori_filesize_set(1,i/10) = ori_filesize.FileSize;
Lena_steo_filesize_set(1,i/10) = steo_filesize.FileSize;
Lena_increased_fs = (Lena_steo_filesize_set - Lena_ori_filesize_set);  %单位（字节）
end