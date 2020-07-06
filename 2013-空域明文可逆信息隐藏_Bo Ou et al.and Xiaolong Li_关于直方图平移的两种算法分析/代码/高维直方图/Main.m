clear
clc
% I = imread('lena.tiff');
I = imread('Baboon.tiff');
origin_I = double(I); 
%% 随机生成嵌入数据
e = 0.09; %嵌入率/BPP
num = floor(512*512*e);
% num = 64281;  %Lena最大嵌入量
% num = 21895;  %Baboon最大嵌入量
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 嵌入数据
[stego_I,emD,sign] = embed(origin_I,D);
%% 提取数据
[recover_I,exD] = extract(stego_I,num,sign);
%% 图像对比
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(stego_I,[]);title('载密图像');
subplot(224);imshow(recover_I,[]);title('恢复图像');
%% 判断结果是否正确
psnrvalue = psnr(origin_I,stego_I)
isequal(emD,exD)
isequal(origin_I,recover_I)
%% 任意嵌入数据数量下的PSNR值
% [PSNR1] = psnr_num(origin_I);
% x =[1:1:14];
% figure;
% plot(x(1,:),PSNR1(1,:),'r-*');
% %legend('高维直方图平移');
% title('高维直方图平移方法在任意嵌入数据数量下的PSNR折线图');
% xlabel('数据嵌入量(单位：5*10^3 bit)','LineWidth',14);  
% ylabel('PNSR值','LineWidth',14); 