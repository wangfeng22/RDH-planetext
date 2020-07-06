clear
clc
I = imread('lena.tiff');
% I = imread('Baboon.tiff');
% I = imread('Barbara.tiff');
origin_I = double(I); 
%% 产生二进制秘密数据
num = 50000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 嵌入数据
[stego_I,emD,LM0,context0,index0,opt_R_S0,end_x0,end_y0] = Embed(origin_I,D);
%% 提取数据
[recover_I,exD] = Extract(stego_I);
%% 图像对比
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(stego_I,[]);title('载密图像');
subplot(224);imshow(recover_I,[]);title('恢复图像');
%% 判断结果是否正确
psnrvalue = PSNR(origin_I,stego_I)
if isequal(emD,exD) == 1
    disp('嵌入数据与提取数据一致!');
else 
    disp('嵌入提取过程错误!');
end
if isequal(origin_I,recover_I) == 1
    disp('原始图像与恢复图像一致!'); 
else 
    disp('恢复图像过程错误!');
end
