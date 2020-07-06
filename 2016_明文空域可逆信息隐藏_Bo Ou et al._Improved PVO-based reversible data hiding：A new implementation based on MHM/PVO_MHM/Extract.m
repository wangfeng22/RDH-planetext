function [recover_I,exD] = Extract(stego_I)
% 函数说明：提取秘密信息，恢复原始图像
% 输入：stego_I（载密图像）
% 输出：recover_I（恢复图像）,exD（秘密信息）
[row,col] = size(stego_I);
%% 先提取最后一行一列的辅助信息
[recover_I_0,opt_R_S,context,index,end_x,end_y,LM] = Side_Extract(stego_I);
%% 初始化补偿参数
r_s = zeros(2,256); %初始化全为0,共有256个直方图
r_s(1,1) = -1;
[Offsets] = Offset_Manners(r_s);
%% 求最优补偿参数
R_S = Offsets{index};
for i=1:32
    R_S(1,i) = R_S(1,i) + opt_R_S(1,i);
    R_S(2,i) = R_S(2,i) + opt_R_S(2,i);
end
%% 提取LSB和秘密信息
recover_I_1 = recover_I_0;
Data = zeros(); %记录嵌入的全部信息
num = 0;
for i=end_x:-1:1
    if i == end_x
        for j=end_y:-1:1
            [U] = Context_Pixels(recover_I_1,context,i,j);
            bi = max(U); %最大值   
            ai = min(U); %最小值  
            t = bi - ai;%噪声水平
            rt = R_S(1,t+1); %最小值的补偿参数                        
            st = R_S(2,t+1); %最大值的补偿参数  
            if recover_I_1(i,j) == bi+st %嵌入了数据：0
                num = num + 1;
                Data(num) = 0;      
            elseif recover_I_1(i,j) == bi+st+1 %嵌入了数据：1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;
                num = num + 1;
                Data(num) = 1;    
            elseif recover_I_1(i,j) == ai+rt  %嵌入了数据：0
                num = num + 1;
                Data(num) = 0;                     
            elseif recover_I_1(i,j) == ai+rt-1  %嵌入了数据：1
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
                num = num + 1;
                Data(num) = 1;     
            elseif recover_I_1(i,j) > bi+st+1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;               
            elseif recover_I_1(i,j) < ai+rt-1     
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
            end
        end
    else
        block = ceil(sqrt(context+1)); %分块大小(开根号向上取整)
        for j=col-block+1:-1:1
            [U] = Context_Pixels(recover_I_1,context,i,j);
            bi = max(U); %最大值   
            ai = min(U); %最小值  
            t = bi - ai;%噪声水平
            rt = R_S(1,t+1); %最小值的补偿参数                        
            st = R_S(2,t+1); %最大值的补偿参数  
            if recover_I_1(i,j) == bi+st %嵌入了数据：0
                num = num + 1;
                Data(num) = 0;      
            elseif recover_I_1(i,j) == bi+st+1 %嵌入了数据：1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;
                num = num + 1;
                Data(num) = 1;    
            elseif recover_I_1(i,j) == ai+rt  %嵌入了数据：0
                num = num + 1;
                Data(num) = 0;                     
            elseif recover_I_1(i,j) == ai+rt-1  %嵌入了数据：1
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
                num = num + 1;
                Data(num) = 1;     
            elseif recover_I_1(i,j) > bi+st+1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;               
            elseif recover_I_1(i,j) < ai+rt-1     
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
            end
        end
    end
end
%% 区分LSB和秘密信息
Data = fliplr(Data); %逆序
len = length(LM);
x = ceil(log2(row));
y = ceil(log2(col));
num_LSB = len+128+4+6+x+y;
LSB = Data(1:num_LSB);
exD = Data(num_LSB+1:num);
%% 嵌入LSB
recover_I_2 = recover_I_1;
% num_LSB = length(LSB);
if num_LSB<=row
    for i=1:num_LSB
        recover_I_2(i,col) = recover_I_2(i,col) + LSB(i);
    end
else
    for i=1:row
        recover_I_2(i,col) = recover_I_2(i,col) + LSB(i);
    end
    for j=1:num_LSB-row
        recover_I_2(row,j) = recover_I_2(row,j) + LSB(row+j);
    end
end
%% 修正图像
recover_I = recover_I_2;
s = 0; %记录溢出溢出像素的个数
for i=1:18
    s = s + LM(i)*(2^(i-1)); 
end
if s ~= 0
    for i=1:s
        loc = 0; %记录溢出位置
        for j=1:18
            bit = LM(i*18+j);
            loc = loc + bit*(2^(j-1)); 
        end
        loc_x = ceil(loc/col); %向上取整
        loc_y = loc - (loc_x-1)*col;
        if recover_I(loc_x,loc_y) == 1
            recover_I(loc_x,loc_y) = 0;
        elseif recover_I(loc_x,loc_y) == 254
            recover_I(loc_x,loc_y) = 255;
        end
    end
end
end
