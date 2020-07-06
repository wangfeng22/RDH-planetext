clear;
clc;
%% 预操作
addpath(genpath('JPEG_Toolbox'));
rng(100,'twister');

Data = round(rand(1,8000)*1);%随机产生01比特，作为嵌入的数据
I = imread('Lena.tiff');%读取tiff图片，用来生成jpeg图片
imwrite(I,'Lena.jpg','jpeg','quality',70);%生成质量因子为XX的JPEG图像
%% 嵌入操作
jpeg_info_ori = jpeg_read('Lena.jpg');%解析JPEG图像
jpeg_info_stego = jpeg_info_ori;%文件复制一份，作为载密图像
quant_tables = jpeg_info_ori.quant_tables{1,1};%获取量化表
oridct = jpeg_info_ori.coef_arrays{1,1};%获取dct系数

[n,m] = size(oridct);
Block_n = 8 * ones(1,n/8);%生成长度为n/8的全8矩阵[8,8,8,8...]
Block_m = 8 * ones(1,m/8);
oriBlockdct = mat2cell(oridct,Block_n,Block_m);%把原来的图像矩阵分割成N个8*8的Block
stegoBlockdct=oriBlockdct;

[zeronum]=Getzeronum(oriBlockdct);
[ACnum]=GetACnum(oriBlockdct);
[R]=GetR(oriBlockdct,quant_tables);

payload=length(Data);
rest=payload;
count=1;

while rest > 0
    positions(count)=R(count,1);
    rest=rest-ACnum(R(count,1),1);
    count=count+1;
end
positions=sort(positions,2);

pos=1;
count=1;
while pos<payload
    [stegoBlockdct,pos]=embed(stegoBlockdct,Data,pos,positions,zeronum(count,1),zeronum(count,2));
    count=count+1;
end

tt=stegoBlockdct;
[side]=Getside(payload,positions);
[stegoBlockdct]=LSB_en(stegoBlockdct,side);

stegodct=cell2mat(stegoBlockdct);%从hxBlockdct细胞矩阵获得hxdct矩阵
jpeg_info_stego.coef_arrays{1,1} = stegodct;%修改后的hxdct系数，写回JPEG信息
jpeg_write(jpeg_info_stego,'stego_Lena.jpg');%保存载密jpeg图像，根据解析信息，重构JPEG图像，获得载密图像


%% 还原操作
jpeg_info_stegoI = jpeg_read('stego_Lena.jpg');%解析stegoI-JPEG图像
jpeg_info_recov=jpeg_info_stegoI;%从stegoI中获得一份数据拷贝

exData=zeros();
pos=1;
count=1;
recBlockdct=tt;
while pos<payload
    [recBlockdct,exData,pos]=extract(recBlockdct,exData,pos,payload,positions,zeronum(count,1),zeronum(count,2));
    count=count+1;
end

redct=cell2mat(recBlockdct);
jpeg_info_recov.coef_arrays{1,1} = redct; %修改后的dct系数 写回 JPEG信息
jpeg_write(jpeg_info_recov,'recov_Lena.jpg');%保存载密jpeg图像  jpeg_write（）是解析工具中的函数  根据解析信息 重构JPEG图像

%% 显示实验结果
ori_jpeg = imread('Lena.jpg');%读取原始jpeg图像
stego_jpeg = imread('stego_Lena.jpg');%读取载密jpeg图像
recov_jpeg = imread('recov_Lena.jpg');%读取恢复jpeg图像
figure;
subplot(2,2,1);imshow(I);title('tiff原始图像');%显示原始tiff图像
subplot(2,2,2);imshow(ori_jpeg);title('jpeg原始图像');%显示原始图像
subplot(2,2,3);imshow(stego_jpeg);title('载密图像');%显示载密图像
subplot(2,2,4);imshow(recov_jpeg);title('恢复图像');%显示恢复图像
%% 检验实验结果
psnrvalue=psnr(ori_jpeg,stego_jpeg)
ans1=isequal(ori_jpeg,recov_jpeg);
ans2=isequal(Data,exData);