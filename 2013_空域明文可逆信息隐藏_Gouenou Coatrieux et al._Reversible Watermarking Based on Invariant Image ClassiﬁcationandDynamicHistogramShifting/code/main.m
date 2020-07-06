clear
clc
I = imread('Lena.tiff');
I2=I;
I=double(I);
[row,col]=size(I);
%for Te=0:1:100%挑选出一个Te使预测效果最好
Te=36;%Lena
%Te=20;%baboon
for i=1:1:row-2
    for j=1:1:col-2
        I1=I(i:i+2,j:j+2);%选择九个像素形成一个像素块
        c=C(I1);%求出像素块中第二大的像素与第二小的像素的差值
        if(c>Te)
        P(i,j)=Blo(I1);%用文中提出的方法预测
        else
        P(i,j)=rhombus(I1);%用菱形预测
        end
    end
end
%SM(Te+1)=sum(sum(E));
%end



