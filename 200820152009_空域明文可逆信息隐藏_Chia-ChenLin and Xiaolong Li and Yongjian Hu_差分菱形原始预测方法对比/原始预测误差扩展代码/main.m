clear
clc
I=imread('lena.tiff');
I=double(I);
pixelnum=20000;                         %秘密信息的数量
data=randi([0,1],1,pixelnum);          %生成秘密信息
P=OriginalPridicationError(I);         %预测误差
% H=GetHis(P);
% bar(-255:255,H);
% plot(-255:255,H)
[I1,endx,endy]=embed(I,P,data,pixelnum);   
ans1=psnr(I,I1);
[I2,rdata]=Reget(I1,pixelnum,endx,endy);
ans2=isequal(I,I2);
ans3=isequal(data,rdata);