function [PV_I,PE_I,Noise_I] = Calculate(I) 
%PV_I表示预测值,PE_I表示预测误差,Noise_I表示噪声水平
[row,col]=size(I); %统计I的行列数
PV_I = I;
PE_I = I;
Noise_I = ones(row,col)*(-1); %全-1矩阵
for i=2:row-2 %行
    for j=2:col-2 %列
        w1 =  I(i-1,j); %上
        w2 =  I(i,j-1); %左
        w3 =  I(i+1,j); %下
        w4 =  I(i,j+1); %右
        w5 =  I(i+1,j-1);
        w6 =  I(i+1,j+1);
        w7 =  I(i+2,j);
        w8 =  I(i,j+2);
        w9 =  I(i+2,j-1);
        w10 =  I(i-1,j+2);
        w11 =  I(i+2,j+1);
        w12 =  I(i+1,j+2);
        w13 =  I(i+2,j+2);
        PV_I(i,j) = floor((w1+w2+w3+w4)/4); %(i,j)处的预测值，上下左右取平均值
        PE_I(i,j) = I(i,j) - PV_I(i,j); %预测误差
        Noise_I(i,j) = abs(w2-w5)+abs(w5-w9)+abs(w3-w7)+abs(w4-w6)+abs(w6-w11)+abs(w10-w8)+abs(w8-w12)+abs(w12-w13)...
            +abs(w4-w8)+abs(w5-w3)+abs(w3-w6)+abs(w6-w12)+abs(w9-w7)+abs(w7-w11)+abs(w11-w13);  %计算噪声水平
    end
end