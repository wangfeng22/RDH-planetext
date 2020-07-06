clear
clc
I = imread('lena.tiff');
% I = imread('Baboon.tiff');
origin_I = double(I); 
%% 产生二进制秘密数据
e = 0.8; %嵌入率/BPP
num = floor(512*512*e);
rand('seed',1); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 嵌入数据
[stego_I,emD,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2] = Embed(origin_I,D);
%% 提取数据
[recover_I,exD] = Extract(stego_I,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2);
%% 图像对比
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(stego_I,[]);title('载密图像');
subplot(224);imshow(recover_I,[]);title('恢复图像');
%% 判断结果是否正确
psnrvalue = PSNR(origin_I,stego_I)
isequal(emD,exD)
isequal(origin_I,recover_I)