clear
clc
addpath(genpath('JPEG_Toolbox'));
addpath(genpath('img'));
imgname='lena.tiff';
%imgname='Baboon.tiff';
%imgname='Pepper.tiff';
%imgname='Tiffany.tiff';
Data = round(rand(1,100000)*1);%随机产生01比特，作为嵌入的数据
count1=1;
for QF=30:20:90;   
count2=1;
for  payload=2000:2000:100000;
%% 数据嵌入
%% 解析JPEG文件
I = imread(imgname);
imwrite(I,'ori.jpg','jpeg','quality',QF);%生成质量因子为QF的JPEG图像
jpeg_info = jpeg_read('ori.jpg');%解析JPEG图像
stego_jpeg_info =jpeg_info;%文件复制一份，作为载密图像
quant_tables = jpeg_info.quant_tables{1,1};%获取量化表
dct_coef = jpeg_info.coef_arrays{1,1};%获取dct系数
[num1,num_1] = jpeg_hist(dct_coef);%绘制非零ac系数直方图 num1=+1个数  num_1=-1个数
oriBlockdct = mat2cell(dct_coef,8 * ones(1,64),8 * ones(1,64));
[ACmatrix,zigzag_blockAC] = GetACmatrix(oriBlockdct);
if payload <= num1+num_1;
    [emdData,numData,ACmatrix,index] = jpeg_emdding(Data,ACmatrix,payload);
else
    break;
end
[stego_blockdct]=Recovery(ACmatrix,zigzag_blockAC);
stego_dct=cell2mat(stego_blockdct);
stego_jpeg_info.coef_arrays{1,1} = stego_dct;   %修改后的DCT系数，写回JPEG信息
jpeg_write(stego_jpeg_info,'stego.jpg');    %保存载密jpeg图像，根据解析信息，重构JPEG图像，获得载密图像
%% 显示
figure(1);
subplot(221);imshow(I);title('tiff原始图像');%显示原始图像
subplot(222);imshow(imread('ori.jpg'));title('jpeg原始图像');%显示JPEG压缩图像
subplot(223);imshow(imread('stego.jpg'));title('载密图像');%显示JPEG载密图像
pause(0.1)
%% 获取PSNR和文件增量 保存相关信息
result(count1,count2).QF=QF;
result(count1,count2).capacity=num1+num_1;
result(count1,count2).payload=payload;
ori_jpeg = imread('ori.jpg');   %读取原始jpeg图像
stego_jpeg = imread('stego.jpg')    ;%读取载密jpeg图像
result(count1,count2).psnr=psnr(ori_jpeg,stego_jpeg);

fid=fopen('stego.jpg','rb');
bit1=fread(fid,'ubit1');
fclose(fid);
fid=fopen('ori.jpg','rb');
bit2=fread(fid,'ubit1');
fclose(fid);
result(count1,count2).increase= length(bit1)-length(bit2);
A(count1,count2)=result(count1,count2).psnr;
B(count1,count2)=result(count1,count2).increase;
count2=count2+1;
end
count1=count1+1;
end