clear;
clc;

addpath(genpath('JPEG_Toolbox'));
rng(100,'twister');
cnt1=1;
for nn=1000%:1000:2000
data = round(rand(1,nn)*1);%随机产生01比特，作为嵌入的数据
imwrite(imread('img/Baboon.tiff'),'ori.jpg','jpeg','quality',70);%生成质量因子为XX的JPEG图像
ori_jpeg_info = jpeg_read('ori.jpg');%解析JPEG图像
stego_jpeg_info = ori_jpeg_info;%文件复制一份，作为载密图像
quant_tables = ori_jpeg_info.quant_tables{1,1};%获取量化表
oridct = ori_jpeg_info.coef_arrays{1,1};%获取dct系数
oriBlockdct = mat2cell(oridct,8 * ones(1,64),8 * ones(1,64));%把原来的图像矩阵分割成N个8*8的Block

%得到AC矩阵
[ACmatrix,zigzag_blockAC] = GetACmatrix(oriBlockdct);

%根据失真选择最佳t
%[t,allbest]=GetT(AC_matrix,quant_tables,payload);
t=4096;

%获得最优区间
[best,all]=GetBest(ACmatrix,quant_tables,t);
payload=length(data);

%嵌入操作
pos=1;
count=1;
while pos<payload
    [ACmatrix,pos]=embed(ACmatrix,data,pos,best(count,:),t);
    count=count+1;
end

%将AC矩阵还原成行列形式
[stego_blockdct]=Recovery(ACmatrix,zigzag_blockAC);

%处理边信息
%side = Getside(t);
side = [0,1];
[stego_blockdct]=LSB_en(stego_blockdct,side);

%得到载密图像
stego_dct=cell2mat(stego_blockdct);
stego_jpeg_info.coef_arrays{1,1} = stego_dct;   %修改后的DCT系数，写回JPEG信息
jpeg_write(stego_jpeg_info,'stego.jpg');    %保存载密jpeg图像，根据解析信息，重构JPEG图像，获得载密图像

%获取PSNR和文件增量
ori_jpeg = imread('ori.jpg');   %读取原始jpeg图像
stego_jpeg = imread('stego.jpg')    ;%读取载密jpeg图像
psnrTable(cnt1)=psnr(ori_jpeg,stego_jpeg);
fid=fopen('stego.jpg','rb');
bit1=fread(fid,'ubit1');
fclose(fid);
fid=fopen('ori.jpg','rb');
bit2=fread(fid,'ubit1');
fclose(fid);
increaseTable(cnt1) = length(bit1)-length(bit2);

cnt1=cnt1+1;
end