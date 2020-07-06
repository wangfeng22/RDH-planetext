function [stego_I,emD,LM,context,index,opt_R_S,end_x,end_y] = Embed(origin_I,D)
% 函数说明：将秘密信息嵌入到原始图像中，生成载密图像；
% 输入：origin_I（原始图像）,D（秘密数据）
% 输出：stego_I（载密图像）,emD（嵌入的信息）
[row,col] = size(origin_I);
num = length(D); 
%% 设置参数,初始预测像素个数
context = 15;
%% 计算溢出信息，修正原始图像
[change_ori_I,LSB,LM] = Overflow(origin_I);
len_LSB = length(LSB);
PS = len_LSB + num; %需要的嵌入容量
%% 求最优参数和修正参数
[context,Offsets,index,opt_R_S,NL,MAX,MIN] = Optimal(change_ori_I,PS,context);
%% 计算修正后的最优参数
R_S = Offsets{index};
for i=1:32
    R_S(1,i) = R_S(1,i) + opt_R_S(1,i);
    R_S(2,i) = R_S(2,i) + opt_R_S(2,i);
end
%% 嵌入LSB和秘密数据
stego_I_0 = change_ori_I; %嵌入秘密信息之后的载密图像
% len_LSB = length(LSB);
num_LSB = 0;
num_emD = 0;
block = ceil(sqrt(context+1)); %分块大小(开根号向上取整)
for i=1:row-block+1             
    for j=1:col-block+1
        if num_emD >= num
            break;
        end
        t = NL(i,j); %噪声水平          
        max = MAX(i,j); %预测内容的最大值        
        min = MIN(i,j); %预测内容的最小值          
        rt = R_S(1,t+1);%最小值的补偿参数                     
        st = R_S(2,t+1);%最大值的补偿参数
        if stego_I_0(i,j) == max + st %嵌入0不变，嵌入1加1
            if num_LSB < len_LSB  %先嵌入边信息
                num_LSB = num_LSB+1;
                data = LSB(num_LSB);
            else  %等边信息嵌入完毕之后再嵌入秘密信息   
                num_emD = num_emD+1;
                data = D(num_emD);
            end
            stego_I_0(i,j) = stego_I_0(i,j) + data;
        elseif stego_I_0(i,j) == min + rt %嵌入0不变，嵌入1减1
            if num_LSB < len_LSB
                num_LSB = num_LSB+1;
                data = LSB(num_LSB);
            else     
                num_emD = num_emD+1;
                data = D(num_emD);
            end
            stego_I_0(i,j) = stego_I_0(i,j) - data;
        elseif stego_I_0(i,j) > max + st %+1
            stego_I_0(i,j) = stego_I_0(i,j) + 1;
        elseif stego_I_0(i,j) < min + rt %-1
            stego_I_0(i,j) = stego_I_0(i,j) - 1;
        end  
        end_x = i;
        end_y = j;
    end
end
%% 嵌入辅助信息:opt_R_S,context,index,(end_x,end_y),LM
[stego_I_1] = Side_Embed(stego_I_0,opt_R_S,context,index,end_x,end_y,LM);
%% 记录载密图像和嵌入的数据
stego_I = stego_I_1;
emD=D(1:num_emD);
end