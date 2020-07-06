function [recover_I_0,opt_R_S,context,index,end_x,end_y,LM] = Side_Extract(stego_I)
% 函数说明：提取辅助信息，并恢复得到不含辅助信息的载密图像
% 输入：stego_I（含有辅助信息的载密图像）
% 输出：recover_I_0（不含辅助信息的载密图像）,opt_R_S（优化参数）,context（预测像素个数）,index（最优补偿参数的索引）,(end_x,end_y)（结束位置）,LM（溢出信息）
[row,col] = size(stego_I);
x = ceil(log2(row));
y = ceil(log2(col));
%% 提取优化参数(128 bits)：opt_R_S
opt_R_S = zeros(2,32); %优化参数(128 bits)：opt_R_S 
for i=1:+2:128  %2 bits表示一个值（0:00，1:01，-1:10，-2:11）
    bit1 = mod(stego_I(i,col),2);
    bit2 = mod(stego_I(i+1,col),2);
    if i <= 64 %前64位表示32个优化参数r(32)
        t = round(i/2);
        if bit1==0 && bit2==0 % 00表示0
            opt_R_S(1,t) = 0;
        elseif bit1==0 && bit2==1 % 01表示1
            opt_R_S(1,t) = 1;   
        elseif bit1==1 && bit2==0 % 10表示-1
            opt_R_S(1,t) = -1;      
        elseif bit1==1 && bit2==1 % 11表示-2
            opt_R_S(1,t) = -2;
        end   
    else %后64位表示32个优化参数s(32)
        t = round((i-64)/2);
        if bit1==0 && bit2==0 % 00表示0
            opt_R_S(2,t) = 0;
        elseif bit1==0 && bit2==1 % 01表示1
            opt_R_S(2,t) = 1;   
        elseif bit1==1 && bit2==0 % 10表示-1
            opt_R_S(2,t) = -1;      
        elseif bit1==1 && bit2==1 % 11表示-2
            opt_R_S(2,t) = -2;
        end 
    end
end
%% 提取预测像素个数(4 bits)：context∈[2,15]
context = 0;
for i=1:4
    bit = mod(stego_I(i+128,col),2);
    context = context + bit*(2^(i-1));
end
%% 提取最优补偿参数的索引(6 bits)：index
index = 0;
for i=1:6
    bit = mod(stego_I(i+128+4,col),2);
    index = index + bit*(2^(i-1));
end
%% 提取结束位置(x+y bits)：(end_x,end_y)
end_x = 0;
end_y = 0;
for i=1:x
    bit = mod(stego_I(i+128+4+6,col),2);
    end_x = end_x + bit*(2^(i-1));
end
for i=1:y
    bit = mod(stego_I(i+128+4+6+x,col),2);
    end_y = end_y + bit*(2^(i-1));
end
%% 提取溢出信息(len bits)：LM
LM = zeros();
num = 0; %记录溢出溢出像素的个数
sum = 128+4+6+x+y; %最后一列中已经提取信息的像素个数
for i=1:x+y
    bit = mod(stego_I(i+sum,col),2);
    LM(i) = bit;
    num = num + bit*(2^(i-1)); 
end
if num ~= 0
    len = (x+y) * num;
    if sum+x+y+len <= row %只在最后一列提取信息
        for i=1:len
            bit = mod(stego_I(i+sum+x+y,col),2);
            LM(i+x+y) = bit;
        end
    else  %在最后一列一行都提取信息
        for i=1:row-sum-x-y
            bit = mod(stego_I(i+sum+x+y,col),2);
            LM(i+x+y) = bit;    
        end
        for j=1:len-(row-sum-x-y)
            bit = mod(stego_I(row,j),2);
            LM(j+row-sum) = bit; 
        end
    end
end
%% 恢复不含辅助信息的载密图像
recover_I_0 = stego_I;
len = (x+y) * num;
if sum+x+y+len <= row %只在最后一列存储了辅助信息
    for i=1:sum+x+y+len
        value = recover_I_0(i,col);
        bit = mod(value,2);
        recover_I_0(i,col) = value - bit;
    end
else
    re = sum+x+y+len-row;
    for i=1:row
        value = recover_I_0(i,col);
        bit = mod(value,2);
        recover_I_0(i,col) = value - bit;
    end
    for j=1:re
        value = recover_I_0(row,j);
        bit = mod(value,2);
        recover_I_0(row,j) = value - bit; 
    end
end
end