clear
clc

addpath JPEG_Toolbox\;
addpath imgs\;


%选择要处理的图片，解析图片，获得DCT矩阵
imwrite(imread('Baboon.tiff'),'Ori_photo.jpg','jpeg','quality',90);     %生成质量因子为XX的JPEG图像
ori_jpeg_info = jpeg_read('Ori_photo.jpg');    %解析JPEG图像
ori_jpeg = imread('Ori_photo.jpg');       %读取原始jpeg图像
stego_jpeg_info = ori_jpeg_info;        %图像解析复制一份，作为载密图像数据
ori_dct = ori_jpeg_info.coef_arrays{1,1};     %获取dct系数
ori_blockdct = mat2cell(ori_dct,8 * ones(1,64),8 * ones(1,64));      %把原来的dct矩阵分割成4096个8*8的Block

TypeA=0;
TypeB=0;
TypeC=0;
TypeD=0;
TypeE=0;
TypeF=0;

for r=1:64
    for c=1:64
       Z_dct=GetZigzag(ori_blockdct{r,c});
       for i=3:2:63
          x=Z_dct(1,i);
          y=Z_dct(1,i+1);
          
          if (x==-1 && y==1) || (x==1 && y==1) || (x==1 && y==-1) || (x==-1 && y==-1)
              TypeA=TypeA+1;
          elseif (x==0 && y==1) || (x==1 && y==0) || (x==0 && y==-1) || (x==-1 && y==0)
              TypeB=TypeB+1;
          elseif abs(x)>1 && abs(y)==1
              TypeC=TypeC+1;
          elseif abs(x)>1 && y==0
              TypeD=TypeD+1;
          elseif abs(y)>1
              TypeE=TypeE+1;
          elseif x==0 && y==0
              TypeF=TypeF+1;
          end
          
       end
    end
end

capacity=TypeA*log2(3)+TypeB+TypeC-30;
fprintf('可扩展系数对的数目 %d, 最大容量为 %d比特\n',TypeA+TypeB+TypeC,round(capacity));










