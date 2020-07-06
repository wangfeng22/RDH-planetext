clear
clc
I=imread('lena.tiff');
A=4;  %每一块A行B列
B=4;
[P,lsum]=DivideAndGetDifferenceImageStep1(I,A,B);                          %生成每一块的差分图像
W=GetImagePeakStep2(P,lsum);                                               %得到每一块的峰值点
Q=ShipStep3(P,W,lsum,A,B);                                                 %对每一个块进行平移，大于峰值点的移动一位
Pixelnum=20000;
S=randi([0,1],1,Pixelnum);                                                 %生成秘密信息
%对每一个块依次嵌入
lstart=1;                                                                  %从s的第一位开始嵌入
Embed=Q;
for i=1:lsum
    %峰值点W（i）
    %差分图像 Q（i，：，：）
    peak=W(i);
    D=Embed;
    [D,lend]=EmbedStep4(i,Embed,S,peak,lstart,Pixelnum,A,B);
    Embed=D;
    lstart=lend;
    if lstart > Pixelnum
        lastkuai=i;
        break;
    end
end
Mark=GetMarkImageStep5(I,Embed,lsum,A,B);                                  %嵌入后的标记图像
[SD,sum]=DivideAndGetDifferenceImageStep1(Mark,A,B);                       %Extrating step1
Reget=zeros(1,Pixelnum);                                                   %提取信息
leend=1;
for i=1:lsum
    if leend>Pixelnum
        break;
    end
    for haha=1:A
        for hahaha=1:B-1
            if SD(i,haha,hahaha) == W(i)
                Reget(leend)=0;
                leend=leend+1;
            elseif SD(i,haha,hahaha)== (W(i)+1)
                Reget(leend)=1;
                leend=leend+1;
            end
            
            if leend > Pixelnum
                break;
            end
        end
        if leend>Pixelnum
                break;
        end
    end
    if leend>Pixelnum
       break;
    end
end
ans1=isequal(S,Reget);                                                     %比较嵌入的信息和提取出来的信息是否相同
RD=RemoveStep3(SD,W,lsum,A,B);                                             %恢复平移              
RH=RegetImage(RD,Mark,I,lsum,A,B);
ans2=isequal(RH,I);
subplot(1,3,1);
imshow(I);
title('原图');
subplot(1,3,2);
imshow(Mark);
title('嵌入后的标记图像');
subplot(1,3,3);
RH=uint8(RH);
imshow(RH);
title('恢复后的图像');



