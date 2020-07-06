function [lc,LM,LMc] = Overflow(x,y,stego_I,s,tl,tr,PE_x5,C_x5)
%(x,y)表示该层中第一个分块的起始位置，stego_I表示上一层嵌入数据后的载密图像
%s、tl、tr表示嵌入参数，PE_x5表示预测误差，C_x5表示复杂度
%lc表示LMc长度，LM表示所有块的信息，LMc表示溢出块信息
[m,n]=size(stego_I); %统计stego_I的行列数
LM = zeros(); %用来记录块信息
LMc = zeros(); %用来记录溢出块信息
k = 0; %记录分块个数
l = 0; %记录溢出块个数
%% 求所有分块信息LM
x0 = x+1; %在3*3分块的中心像素处嵌入信息
y0 = y+1;
for i=x0:+3:m
    for j=y0:+3:n
        if i+1<=m && j+1<=n  %防止越界
            k=k+1; 
            x5_value = stego_I(i,j); %分块中心像素值
            x5_max1 = x5_value + tr;
            x5_min1 = x5_value - tl;
            e5 = PE_x5(k);
            x5_max2 = x5_value + floor(e5) + 1;
            x5_min2 = x5_value + floor(e5) + 0;
            C = C_x5(k);
            if x5_max1>255 && x5_min1<0 && x5_max2>255 && x5_min2<0 && C<s
                LM(k) = 1; %溢出块
                l = l+1;
            else     
                LM(k) = 0; %嵌入块或平移块
            end
        end
    end
end
%% 求溢出块信息LMc
len_k = ceil(log2(k)); %k的二进制位数，向上取整
lc = (l+1)*len_k;  %表示LMc的长度
num = l; % l→溢出块个数
for i=len_k:-1:1 %LMc前len_k比特表示溢出块个数
    bin = mod(num,2);  %取余数
    num = floor(num/2);%取商,向下取整
    LMc(i) = bin;
end
num_l = 0;%用来记录第几个溢出块
for i=1:k %记录每个溢出块的位置
    if LM(i)==1 %溢出块
        num_l = num_l+1;
        loc = i; %记录位置
        for j=(num_l+1)*len_k:-1:num_l*len_k+1
            bin = mod(loc,2);  %取余数
            loc = floor(loc/2);%取商
            LMc(i) = bin;
        end
    end
end