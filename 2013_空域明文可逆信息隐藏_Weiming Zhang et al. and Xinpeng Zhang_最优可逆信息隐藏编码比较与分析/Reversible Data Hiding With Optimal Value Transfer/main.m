clear all
clc
for itenum = 10000:10000:110000
im = imread('lena.bmp');
im = double(im);
[size1,size2] = size(im);
%%
%求预测误差
[iminter,X1] = GetInterImg(im,1);
% iminter = GetInterImg1(im);
Err = im - iminter;

Err1 = [Err(1:2:size1,1:2:size2); Err(2:2:size1,2:2:size2)];%取出setA的误差值，并纵向的矩阵连接
im1 = [im(1:2:size1,1:2:size2); im(2:2:size1,2:2:size2)];%取出setA的像素值，并纵向的矩阵连接
stegoim1 = im1;
%%
%求取矩阵以及负载失真
[HMat, Payl, Dist, drate, L, R, CHist, La,temph,sumhist,OriHist,indmx] = GetHMat1(Err1,itenum);  
%  return

hh1 = hist(Err1(:),[L-1:1:R+1]); 
hh1 = hh1(1,2:R-L+2);
S = 0;
for k = 1:R-L+1
    S = S + hh1(1,k)*GetEntropy(HMat(k+20,:)/sum(HMat(k+20,:)));
end
S;
%%
%嵌入部分
[stegoim1,P1,P2,number0255,number0255r]=ReverEmbed(Err1,im1,HMat, Payl, Dist, drate, L, R, CHist);

% psnr(stegoim1,im1)
% (P1-P2)/(size1*size2/2)
PurePayload = P1 - P2 - number0255 - number0255r * 4 - (R-L+1)*8;%纯载荷

stegoim = im;
%得到载密图像
for i = 1:2:size1
    for j = 1:2:size2
        stegoim(i,j) = stegoim1((i+1)/2,(j+1)/2);
    end
end
for i = 2:2:size1
    for j = 2:2:size2
        stegoim(i,j) = stegoim1(i/2+size1/2,j/2);
    end
end
%%
[iminter,X2] = GetInterImg(stegoim,2);
Err = stegoim - iminter;
Err2 = [Err(2:2:size1,1:2:size2); Err(1:2:size1,2:2:size2)];
im2 = [im(2:2:size1,1:2:size2); im(1:2:size1,2:2:size2)];
stegoim2 = im2; 
[size1im2,size2im2] = size(im2); 
%%
[HMat, Payl, Dist, drate, L, R, CHist] = GetHMat2(Err2, La);
[stegoim2(1:size1im2,1:size2im2-16),P1,P2,number0255,number0255r]=ReverEmbed(Err2(1:size1im2,1:size2im2-16),im2(1:size1im2,1:size2im2-16),HMat, Payl, Dist, drate, L, R, CHist);
PurePayload = PurePayload + P1 - P2 - number0255 - number0255r * 4 - (R-L+1)*8;

rand('seed',17);
stegoim2(1:size1im2,size2im2-15:size2im2) = im2(1:size1im2,size2im2-15:size2im2) - mod(im2(1:size1im2,size2im2-15:size2im2),2) + round(rand(size1im2,16));

for i = 2:2:size1
    for j = 1:2:size2
        stegoim(i,j) = stegoim2(i/2,(j+1)/2) ;
    end
end
for i = 1:2:size1
    for j = 2:2:size2
        stegoim(i,j) = stegoim2((i+1)/2+size1/2,j/2);
    end
end

% psnr(stegoim2,im2)
% (P1-P2)/(size1*size2/2)
itenum
psnr(stegoim,im)
PurePayload/(size1*size2)

end
                    