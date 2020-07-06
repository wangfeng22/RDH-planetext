clear
clc
addpath JPEG_Toolbox\;
addpath imgs\;
rng(12,'twister');        %初始化种子
payload=4000;
data = round(rand(1,payload)*1);     

%选择要处理的图片，解析图片，获得DCT矩阵
imwrite(imread('Splash.tiff'),'Ori_photo.jpg','jpeg','quality',90);     %生成质量因子为XX的JPEG图像
ori_jpeg_info = jpeg_read('Ori_photo.jpg');    %解析JPEG图像
ori_jpeg = imread('Ori_photo.jpg');       %读取原始jpeg图像
stego_jpeg_info = ori_jpeg_info;        %图像解析复制一份，作为载密图像数据
quant_tables = ori_jpeg_info.quant_tables{1,1};%获取量化表
ori_dct = ori_jpeg_info.coef_arrays{1,1};     %获取dct系数
ori_blockdct = mat2cell(ori_dct,8 * ones(1,64),8 * ones(1,64));      %把原来的dct矩阵分割成4096个8*8的Block
stego_blockdct=ori_blockdct;

%根据量化表，对32个位置进行优先级排序
[R]=GetR(quant_tables);

%提取前56个AC1的最低有效位，作为载荷的一部分
AC1_LSBs=Get_AC1_LSBs(stego_blockdct,56);
data(1,payload+1:payload+56)=AC1_LSBs;
payload=payload+56;

%统计每个块AC系数值为0的数目，并按降序排列
[zeronum]=Getzeronum(stego_blockdct);      

%得到交换表
[exchange_table]=Getexchange_table(stego_blockdct);          
store_psnr=zeros(1,32);            %存储每个Cv对应的psnr
pos=0;
count=1;
flag=0;
% %
% [ACmatrix,zigzag_blockAC] = GetACmatrix(stego_blockdct);
% [ACmatrix0,ACmatrix1,ACmatrixU]=muti_histograms(ACmatrix);
% [stego_blockdct]=Recovery(ACmatrix0,zigzag_blockAC);
%从最小Cv开始，进行模拟嵌入，记录每个Cv对应的psnr
for  Cv=1:32                  
        
        while pos<payload  
                if count>4096 
                    flag=1;
                    break;
                end
                [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv,exchange_table,R);    
                count=count+1;
        end
        
        % 生成载密图像，并记录对应的PSNR
        stego_dct=cell2mat(stego_blockdct);       %从blockdct细胞矩阵获得dct矩阵
        stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %修改后的dct系数，写回JPEG信息
        jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %保存载密jpeg图像
        stego_jpeg = imread('stego_photo.jpg');       %读取载密jpeg图像
        if flag==0
           store_psnr(1,Cv)=psnr(ori_jpeg ,stego_jpeg);
        else
            store_psnr(1,Cv)=0;
        end
        
        pos=0;
        count=1;
        flag=0;
        stego_blockdct=ori_blockdct;
end

if store_psnr(1,32)==0
    fprintf('容量不够\n');
end

%找到最好的psnr对应的Cv
[~,best_Cv]=find(store_psnr==max(store_psnr));          

%用最优的Cv进行嵌入，并把边信息嵌入到AC1中
Cv=best_Cv;
pos=0;
count=1;
stego_blockdct=ori_blockdct;
while pos<payload  
       [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv,exchange_table,R);     
       count=count+1;
end

[side]=Getside(payload,Cv,exchange_table);     %将边信息(payload,Cv,exchange_table)从十进制数转为二进制数
[stego_blockdct]=LSB_en(stego_blockdct,side);       %把边信息嵌入到AC1中

%生成载密图像，并计算PSNR
stego_dct=cell2mat(stego_blockdct);       %从blockdct细胞矩阵获得dct矩阵
stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %修改后的dct系数，写回JPEG信息
jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %保存载密jpeg图像
stego_jpeg = imread('stego_photo.jpg');       %读取载密jpeg图像
best_psnr=psnr(ori_jpeg ,stego_jpeg);
fprintf('best_psnr=%f   \n',best_psnr);

fid=fopen('stego_photo.jpg','rb');
bit1=fread(fid,'ubit1');
fclose(fid);
fid=fopen('Ori_photo.jpg','rb');
bit2=fread(fid,'ubit1');
fclose(fid);
increaseTable = length(bit1)-length(bit2);
fprintf('increfilesize=%f \n',increaseTable);
%---------------------------------------------------以下为提取流程---------------------------------------------------------------------------
stego_jpeg_info = jpeg_read('stego_photo.jpg');      %解析stego-JPEG图像
quant_tables = stego_jpeg_info.quant_tables{1,1};%获取量化表
recov_jpeg_info=stego_jpeg_info;                       %图像解析复制一份，作为恢复图像数据
stego_dct= stego_jpeg_info.coef_arrays{1,1};     %获取载密图像的dct系数
%提取数据，并恢复图像
[re_dct,exData]=Recover(stego_dct,quant_tables);

%生成恢复图像
recov_jpeg_info.coef_arrays{1,1} = re_dct;        %修改后的dct系数 写回 JPEG信息
jpeg_write(recov_jpeg_info,'recov_photo.jpg');    %保存载密jpeg图像    根据解析信息 重构JPEG图像
re_jpeg = imread('recov_photo.jpg');       %读取恢复jpeg图像

%判断数据是否准确提取，图像是否准确恢复
ans1=isequal(ori_jpeg,re_jpeg);
ans2=isequal(exData,data);
if ans1==1 && ans2==1
    fprintf('数据正确提取，图像准确恢复\n');
end

