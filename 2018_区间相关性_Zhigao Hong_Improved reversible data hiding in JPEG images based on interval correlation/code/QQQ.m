clear;
clc;
list=dir('result');
k=length(list)/2; %图片集长度
sumPSNR20=zeros(1,50);
sumPSNR40=zeros(1,50);
sumPSNR60=zeros(1,50);
sumPSNR80=zeros(1,50);
sumIncrease20=zeros(1,50);
sumIncrease40=zeros(1,50);
sumIncrease60=zeros(1,50);
sumIncrease80=zeros(1,50);
num20=zeros(1,50);
num40=zeros(1,50);
num60=zeros(1,50);
num80=zeros(1,50);
summ=zeros(96,2);
cnt=0;
for i=3:8:k %处理img文件夹中的每一张图片
    cnt=cnt+1;
    xxx=strcat('----------------------------------------------------------------------------',num2str(cnt));
    fprintf('%s\n',xxx);
%     if (cnt==36||cnt==94||cnt==93||cnt==52||cnt==44||cnt==88||cnt==53||cnt==79||cnt==60||cnt==95||cnt==29||cnt==76||cnt==69||cnt==82||cnt==28||cnt==41||cnt==51||cnt==80||cnt==62||cnt==77||cnt==75||cnt==4||cnt==78||cnt==83||cnt==90)
%         continue;
%     end
    for t=0:2:6
        xx = strcat('C:\Users\ZG Hong\Desktop\实验代码\优化1\result\',list(i+t).name);
        fprintf('%s\n',xx);
        yy = strcat('C:\Users\ZG Hong\Desktop\实验代码\优化1\result\',list(i+t+1).name);
        fprintf('%s\n',yy);
        load(xx);
        load(yy);
        len = length(psnrTable);
        summ(cnt,1)=cnt;
        for tt=1:len
            summ(cnt,2)=summ(cnt,2)+(psnrTable(tt));
        end
        if t==0
            for j=1:len
                sumPSNR20(j)=sumPSNR20(j)+psnrTable(j);
                sumIncrease20(j)=sumIncrease20(j)+increaseTable(j);
                num20(j)=num20(j)+1;
            end
        elseif t==2
            for j=1:len
                sumPSNR40(j)=sumPSNR40(j)+psnrTable(j);
                sumIncrease40(j)=sumIncrease40(j)+increaseTable(j);
                num40(j)=num40(j)+1;
            end
        elseif t==4
            for j=1:len
                sumPSNR60(j)=sumPSNR60(j)+psnrTable(j);
                sumIncrease60(j)=sumIncrease60(j)+increaseTable(j);
                num60(j)=num60(j)+1;
            end
        else
            for j=1:len
                sumPSNR80(j)=sumPSNR80(j)+psnrTable(j);
                sumIncrease80(j)=sumIncrease80(j)+increaseTable(j);
                num80(j)=num80(j)+1;
            end
        end
    end
end
summ=sortrows(summ,-2);
ansPSNR=zeros(4,50);
ansPSNR(1,:)=sumPSNR20./num20;
ansPSNR(2,:)=sumPSNR40./num40;
ansPSNR(3,:)=sumPSNR60./num60;
ansPSNR(4,:)=sumPSNR80./num80;
ansIncrease=zeros(4,50);
ansIncrease(1,:)=sumIncrease20./num20;
ansIncrease(2,:)=sumIncrease40./num40;
ansIncrease(3,:)=sumIncrease60./num60;
ansIncrease(4,:)=sumIncrease80./num80;
save('PSNR','ansPSNR');
save('FileSize','ansIncrease');