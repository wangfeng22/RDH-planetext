clear
clc
%JPEG解析工具的当前路径 根据实际情况
addpath(genpath('JPEG_Toolbox'));
payload =100; %嵌入容量控制变量
Data = round(rand(1,payload)*1);%随机产生01比特，作为嵌入的数据
lsb_bit=200;%用于嵌入的lsb数，要>payload
I = imread('Lena.tiff');
i = 80;%60,70,80
QF = i;%量化因子
imwrite(I,'Lena.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图象
imwrite(I,'Ori_Lena.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像
%% 解析JPEG文件
jpeg_info = jpeg_read('Lena.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
ori_jpeg_80 = imread('Lena.jpg');%读取原始jpeg图像
quant_tables = jpeg_info.quant_tables{1,1};%获取量化表 
dct_coef = jpeg_info.coef_arrays{1,1};%获取dct系数
%% 嵌入数据
[jpeg_info_stego,E0,E1]=emdding(Data,dct_coef,jpeg_info,payload,lsb_bit);
jpeg_write(jpeg_info_stego,'stego_Lena.jpg');%保存载密jpeg图像  jpeg_write（）是解析工具中的函数  根据解析信息 重构JPEG图像
stego_jpeg_80 = imread('stego_Lena.jpg');%读取载密jpeg图像 
%% 提取数据
stego_jpeg_info = jpeg_read('stego_Lena.jpg');%再次解析JPEG 载密图像  
[stego_jpeg_info,extData] = extract(stego_jpeg_info,payload,lsb_bit,E0,E1); %提取函数
jpeg_write(stego_jpeg_info,'re_Lena.jpg');%保存恢复jpeg图像 
re_jpeg_80 = imread('re_Lena.jpg');%读取恢复jpeg图像
%% 显示
figure;
subplot(221);imshow(I);title('tiff原始图像');%显示原始图像
subplot(222);imshow(ori_jpeg_80);title('jpeg原始图像');%显示JPEG压缩图像
subplot(223);imshow(stego_jpeg_80);title('载密图像');%显示stego_jpeg_80
subplot(224);imshow(re_jpeg_80);title('恢复图像');%显示恢复图像
%% 图像质量比较
psnrvalue1 = psnr(ori_jpeg_80,stego_jpeg_80);%比较 原始图像 与 载密图像
psnrvalue2 = psnr(ori_jpeg_80,re_jpeg_80);%比较 原始图像 与 恢复图像
v = isequal(Data,extData);
if psnrvalue2 == -1
    disp('恢复图像与原始图像完全一致。');
elseif psnrvalue2 ~= -1
    disp('warning！恢复图像与原始图像不一致！');
end
if v == 1
    disp('提取数据与嵌入数据完全一致。');
elseif v ~= 1
    disp('warning！提取数据与嵌入数据不一致!');
end
%% 文件大小增加分析
ori_filesize = imfinfo('Ori_Lena.jpg');
steo_filesize = imfinfo('stego_Lena.jpg');
Lena_increased_fs = (ori_filesize.FileSize -steo_filesize.FileSize);        %单位（字节）