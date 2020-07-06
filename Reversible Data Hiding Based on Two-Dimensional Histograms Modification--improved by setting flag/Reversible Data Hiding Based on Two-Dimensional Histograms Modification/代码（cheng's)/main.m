clear
clc

addpath JPEG_Toolbox\;
addpath imgs\;

rng(12,'twister');        %初始化种子
payload=3000;
data = round(rand(1,payload)*1);     

%选择要处理的图片，解析图片，获得DCT矩阵
imwrite(imread('Lax.tiff'),'Ori_photo.jpg','jpeg','quality',80);     %生成质量因子为XX的JPEG图像
ori_jpeg_info = jpeg_read('Ori_photo.jpg');    %解析JPEG图像
ori_jpeg = imread('Ori_photo.jpg');       %读取原始jpeg图像
stego_jpeg_info = ori_jpeg_info;        %图像解析复制一份，作为载密图像数据
ori_dct = ori_jpeg_info.coef_arrays{1,1};     %获取dct系数
ori_blockdct = mat2cell(ori_dct,8 * ones(1,64),8 * ones(1,64));      %把原来的dct矩阵分割成4096个8*8的Block
stego_blockdct=ori_blockdct;

%提取前30个AC1的最低有效位，作为载荷的一部分
AC1_LSBs=Get_AC1_LSBs(stego_blockdct,30);
data(1,payload+1:payload+30)=AC1_LSBs;
payload=payload+30;

%统计每个块AC系数值为0的数目
[zeronum]=Getzeronum(stego_blockdct);         

%找到能满足嵌入容量的最小Cv
[min_Cv]=minimum_Cv(stego_blockdct,data,zeronum);              

result=zeros((32-min_Cv+1)*63,3);           %记录实验结果，格式为（Cv，Th，PSNR）
num=1;
pos=0;
count=1;
flag=1;

%从满足容量的最小Cv开始，进行模拟嵌入，记录每个{Cv，Th}对应的psnr
for  Cv=min_Cv:32                  
    for Th=0:62
        
        while pos<payload  
             if zeronum(count,3)>=Th         %零系数大于Th的块被用于嵌入
                [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv);    
             end
             count=count+1;
             if count>4096           %容量不够，flag置0
                 flag=0;
                 break;
             end
        end

        % 生成载密图像，并记录对应的PSNR
        if flag==1
        stego_dct=cell2mat(stego_blockdct);       %从blockdct细胞矩阵获得dct矩阵
        stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %修改后的dct系数，写回JPEG信息
        jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %保存载密jpeg图像
        stego_jpeg = imread('stego_photo.jpg');       %读取载密jpeg图像
        result(num,1)=Cv;
        result(num,2)=Th;
        result(num,3)=psnr(ori_jpeg ,stego_jpeg);
        else
        result(num,1)=Cv;
        result(num,2)=Th;
        result(num,3)=0;
        end
        
        flag=1;
        num=num+1;
        pos=0;
        count=1;
        stego_blockdct=ori_blockdct;
    end
end

%整理数据，找到最优的Cv和Th
result=sortrows(result,-3);
best_Cv=result(1,1);
best_Th=result(1,2);

%用最优的Cv和Th进行嵌入，并把边信息嵌入到AC1中
Cv=best_Cv;
Th=best_Th;
pos=0;
count=1;
stego_blockdct=ori_blockdct;
while pos<payload  
    if zeronum(count,3)>=Th            %零系数大于Th的块被用于嵌入
       [stego_blockdct,pos]=embed(stego_blockdct,data,pos,zeronum(count,1),zeronum(count,2),Cv);     
    end
    count=count+1;
end

[side]=Getside(payload,Cv,Th);     %将边信息(payload,Cv,Th)从十进制数转为二进制数
[stego_blockdct]=LSB_en(stego_blockdct,side);       %把边信息嵌入到AC1中

%生成载密图像，并计算PSNR
stego_dct=cell2mat(stego_blockdct);       %从blockdct细胞矩阵获得dct矩阵
stego_jpeg_info.coef_arrays{1,1} = stego_dct;     %修改后的dct系数，写回JPEG信息
jpeg_write(stego_jpeg_info,'stego_photo.jpg');     %保存载密jpeg图像
stego_jpeg = imread('stego_photo.jpg');       %读取载密jpeg图像


best_psnr=psnr(ori_jpeg ,stego_jpeg);
fprintf('best_psnr=%f   \n',best_psnr);





%---------------------------------------------------以下为提取流程---------------------------------------------------------------------------



stego_jpeg_info = jpeg_read('stego_photo.jpg');      %解析stego-JPEG图像
recov_jpeg_info=stego_jpeg_info;                       %图像解析复制一份，作为恢复图像数据
stego_dct= stego_jpeg_info.coef_arrays{1,1};     %获取载密图像的dct系数

%提取数据，并恢复图像
[re_dct,exData]=Recover(stego_dct);

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