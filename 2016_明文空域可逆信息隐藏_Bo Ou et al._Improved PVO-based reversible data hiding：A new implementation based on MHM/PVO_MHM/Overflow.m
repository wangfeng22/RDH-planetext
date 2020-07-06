function [change_ori_I,LSB,LM] = Overflow(origin_I)
% 函数说明：计算原始图像的溢出信息，并修正原始图像
% 输入：origin_I（原始图像）
% 输出：change_ori_I（修正图像）,LSB（原始图像中用来存储边信息的像素的LSB）,LM（溢出信息）
change_ori_I = origin_I;
[row,col] = size(origin_I);
%% 统计溢出信息
num = 0; %计数，溢出像素个数
Location = zeros(); %记录位置
for i=1:row %最后一行一列肯定不嵌入信息
    for j=1:col
        if origin_I(i,j) == 0 %有可能下溢，+1
            num = num+1;
            Location(num) = (i-1)*col + j; %位置信息
            change_ori_I(i,j) = 1;
        elseif origin_I(i,j) == 255 %有可能上溢，-1
            num = num+1;
            Location(num) = (i-1)*col + j; %位置信息
            change_ori_I(i,j) = 254;   
        end
    end
end
LM_loc = zeros(); %溢出像素位置
x = ceil(log2(row));
y = ceil(log2(col));
for i=1:num
    temp = Location(i);
    n = (i-1)*(x+y);
    for j=1:x+y
        LM_loc(n+j) = mod(temp,2);
        temp = floor(temp/2);
    end
end
LM_num = zeros(); %溢出像素个数
temp = num;
for i=1:x+y  %规格row*col图像有2^(x+y)个像素
    LM_num(i) = mod(temp,2);
    temp = floor(temp/2);
end
if num == 0
    LM = LM_num;
else
    LM = [LM_num,LM_loc];
end
%% 置换LSB，保证嵌入提取像素值相同
LSB = zeros();
L = length(LM);
if L+138+(x+y) <= row %最后一列能存储边信息
    for i=1:L+138+(x+y)
        value = change_ori_I(i,col);
        LSB(i) = mod(value,2);
        change_ori_I(i,col) = value - LSB(i);
    end
else
    re = L-(row-138-x-y);
    for i=1:row
        value = change_ori_I(i,col);
        LSB(i) = mod(value,2);
        change_ori_I(i,col) = value - LSB(i);
    end
    for j=1:re %剩下的在最后一行存储
        value = change_ori_I(row,j);
        LSB(row+j) = mod(value,2);
        change_ori_I(row,j) = value - LSB(row+j); 
    end
end
end