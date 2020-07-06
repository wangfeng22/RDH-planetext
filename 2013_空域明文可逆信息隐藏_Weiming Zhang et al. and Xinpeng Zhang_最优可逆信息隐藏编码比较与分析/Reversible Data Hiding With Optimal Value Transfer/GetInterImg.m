function [iminter,X]=GetInterImg(im,label)

im = double(im);
[size1,size2] = size(im);%读取im的长和宽

iminter = zeros(size1,size2);%为iminter设定空间
%%
%预测值（边缘的预测值）
iminter(1,1) = (im(1,2)+im(2,1))/2;%第一个预测值
iminter(1,size2) = (im(1,size2-1)+im(2,size2))/2;%右上角预测值
iminter(size1,size2) = (im(size1,size2-1)+im(size1-1,size2))/2;%最后一个预测值
iminter(size1,1) = (im(size1,2)+im(size1-1,1))/2;%左下角的预测值
iminter(1,2:size2-1) = (im(1,1:size2-2)+im(1,3:size2)+im(2,2:size2-1))/3;%第一行除去两端两个值后的预测值
iminter(2:size1-1,1) = (im(2:size1-1,2)+im(1:size1-2,1)+im(3:size1,1))/3;%第一列除去一端两个值后的预测值
iminter(size1,2:size2-1) = (im(size1,1:size2-2)+im(size1,3:size2)+im(size1-1,2:size2-1))/3;%最后一行除去一端一个值后的预测值
iminter(2:size1-1,size2) = (im(2:size1-1,size2-1)+im(1:size1-2,size2)+im(3:size1,size2))/3;%最后一列除去一端一个值后的预测值

% iminter(2:size1-1,2:size2-1) = (im(2:size1-1,1:size2-2)+im(2:size1-1,3:size2)+im(1:size1-2,2:size2-1)+im(3:size1,2:size2-1))/4;
% iminter(2:size1-1,2:size2-1) = ((im(2:size1-1,1:size2-2)+im(2:size1-1,3:size2))*0.65+(im(1:size1-2,2:size2-1)+im(3:size1,2:size2-1))*0.35)/2;
%%
%计算权重与预测值
if label == 1
B = [im(2:2:size1-1,2:2:size2-1); im(3:2:size1-1,3:2:size2-1)];%纵向的矩阵连接，先取奇数行，再取偶数行，连接在一起
B = B(:);%将矩阵的数据从上往下取排列成一列
A = zeros(length(B),4);%给A赋以B行4列的矩阵
Temp = [im(1:2:size1-2,2:2:size2-1); im(2:2:size1-2,3:2:size2-1)];
A(:,1) = Temp(:);%将矩阵A的第一列数据替换为temp从上往下取排列成一列的数值
Temp = [im(3:2:size1,2:2:size2-1); im(4:2:size1,3:2:size2-1)];
A(:,2) = Temp(:);%将矩阵A的第二列数据替换为temp从上往下取排列成一列的数值
Temp = [im(2:2:size1-1,1:2:size2-2); im(3:2:size1-1,2:2:size2-2)];
A(:,3) = Temp(:);%将矩阵A的第三列数据替换为temp从上往下取排列成一列的数值
Temp = [im(2:2:size1-1,3:2:size2); im(3:2:size1-1,4:2:size2)];
A(:,4) = Temp(:);%将矩阵A的第四列数据替换为temp从上往下取排列成一列的数值
X = pinv(A'*A)*(A'*B);%产生与A'相同尺寸的矩阵X                                                                                                                   
iminter(2:size1-1,2:size2-1) = im(1:size1-2,2:size2-1)*X(1,1) + im(3:size1,2:size2-1)*X(2,1) + im(2:size1-1,1:size2-2)*X(3,1) + im(2:size1-1,3:size2)*X(4,1);
%除去第一行第一列后的每个像素值求预测值
else
B = [im(2:2:size1-1,3:2:size2-1); im(3:2:size1-1,2:2:size2-1)];
B = B(:);
A = zeros(length(B),4);
Temp = [im(1:2:size1-2,3:2:size2-1); im(2:2:size1-2,2:2:size2-1)];
A(:,1) = Temp(:);
Temp = [im(3:2:size1,3:2:size2-1); im(4:2:size1,2:2:size2-1)];
A(:,2) = Temp(:);
Temp = [im(2:2:size1-1,2:2:size2-2); im(3:2:size1-1,1:2:size2-2)];
A(:,3) = Temp(:);
Temp = [im(2:2:size1-1,4:2:size2); im(3:2:size1-1,3:2:size2)];
A(:,4) = Temp(:);
X = pinv(A'*A)*(A'*B);
iminter(2:size1-1,2:size2-1) = im(1:size1-2,2:size2-1)*X(1,1) + im(3:size1,2:size2-1)*X(2,1) + im(2:size1-1,1:size2-2)*X(3,1) + im(2:size1-1,3:size2)*X(4,1);
end    
%%

iminter = round(iminter);