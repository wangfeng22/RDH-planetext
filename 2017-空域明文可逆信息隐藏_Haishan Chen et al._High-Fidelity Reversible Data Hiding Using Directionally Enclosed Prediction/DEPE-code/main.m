clear
clc
I=imread('H:\大创项目\图像\Lena.tiff');
I=double(I);
pixelnum=50000;%秘密信息的数量
data=randi([0,1],1,pixelnum);           %生成秘密信息
[PExh,PExv,PE]=DirectionalPredictionValue(I);       %预测误差
H=GetHis(PE);
bar(-255:255,H);
[I1,end1,flg]=Embed(I,data,pixelnum);
[rdata,I2]=Extract(I1,end1,flg,pixelnum);
figure;
I=uint8(I);
I1=uint8(I1);
I2=uint8(I2);
subplot(1,3,1);imshow(I);title('tiff原始图像');%显示原始图像
subplot(1,3,2);imshow(I1);title('载密图像');%显示载密图像
subplot(1,3,3);imshow(I2);title('恢复后的图像');%显示恢复图像
ans1=psnr(I,I1);
ans2=isequal(I,I2);
ans3=isequal(data,rdata);
if ans2 == 1
    disp('恢复后的图像与原始图像一样');
elseif ans2 ~= 1
    disp('warning！恢复图像与原始图像不一致！');
end
if ans3 == 1
    disp('提取出的数据与嵌入数据一样');
elseif ans3 ~= 1
    disp('warning！提取数据与嵌入数据不一致！');
end

