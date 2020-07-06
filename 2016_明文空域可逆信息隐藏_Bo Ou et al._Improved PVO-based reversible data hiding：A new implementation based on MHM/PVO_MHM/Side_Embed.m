function [stego_I_1] = Side_Embed(stego_I_0,opt_R_S,context,index,end_x,end_y,LM)
% 函数说明：将辅助信息嵌入到载密图像的最后一行一列
% 输入：stego_I_0（载密图像）,opt_R_S（优化参数）,context（预测像素个数）,index（最优补偿参数的索引）,(end_x,end_y)（结束位置）,LM（溢出信息）
% 输出：stego_I_1（含有辅助信息的载密图像）
[row,col] = size(stego_I_0);
%% 用0/1 bit记录辅助信息
x = ceil(log2(row));
y = ceil(log2(col));
len = length(LM);
Side = zeros(); %共138+(x+y)+len bits的辅助信息(128+4+6+(x+y)+len)
s = 0; %计数
%% 记录优化参数(128 bits)：opt_R_S
for i=1:2  
    for j=1:32
        opt = opt_R_S(i,j); %只有-2、-1、0、1四个值
        if opt == 0  % 2 bit表示：00 
            Side(s+1) = 0;
            Side(s+2) = 0;
        elseif opt == 1 % 2 bit表示：01
            Side(s+1) = 0;
            Side(s+2) = 1;
        elseif opt == -1 % 2 bit表示：10
            Side(s+1) = 1;
            Side(s+2) = 0;
        elseif opt == -2 % 2 bit表示：11
            Side(s+1) = 1;
            Side(s+2) = 1;
        end  
        s = s + 2;
    end
end
%% 记录预测像素个数(4 bits)：context∈[2,15]
temp1 = context; 
for i=1:4 
    Side(s+i) = mod(temp1,2);
    temp1 = floor(temp1/2);
end
s = s + 4;
%% 记录最优补偿参数的索引(6 bits)：index
temp2 = index;
for i=1:6 
    Side(s+i) = mod(temp2,2);
    temp2 = floor(temp2/2);
end
s = s + 6;
%% 记录结束位置(x+y bits)：(end_x,end_y)
temp3 = end_x;
for i=1:x 
    Side(s+i) = mod(temp3,2);
    temp3 = floor(temp3/2);
end
s = s + x;
temp4 = end_y;
for i=1:y 
    Side(s+i) = mod(temp4,2);
    temp4 = floor(temp4/2);
end
s = s + y;
%% 记录溢出信息(len bits)：LM
for i=1:len
    Side(s+i) = LM(i);
end
s = s + len;
%% 嵌入辅助信息
stego_I_1 = stego_I_0;
if s <= row %最后一列能存储边信息
    for i=1:s
        stego_I_1(i,col) = stego_I_1(i,col) + Side(i);
    end  
else
    re = s-row;
    for i=1:row
        stego_I_1(i,col) = stego_I_1(i,col) + Side(i);
    end
    for j=1:re %剩下的在最后一行存储
        stego_I_1(row,j) = stego_I_1(row,j) + Side(row+j); 
    end
end
end