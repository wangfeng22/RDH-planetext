function [index] = Offset_Select(I,context,NL,MAX,MIN,Offsets,PS)
% 函数说明：求解54组补偿参数中最优的一组补偿参数
% 输入：I（图像矩阵）,context（预测像素个数）,NL（噪声水平）,MAX（预测内容的最大值）,MIN（预测内容的最小值）,Offsets（54组补偿参数）,PS（需要的嵌入容量）
% 输出：index（最优补偿参数的索引）
[row,col] = size(I);
block = ceil(sqrt(context+1)); %分块大小(开根号向上取整)
group = length(Offsets);
%% 分别计算54组参数中的嵌入容量和总体失真
EC = zeros(1,group); %记录每组参数的嵌入容量
ED = zeros(1,group); %记录每组参数的总体失真
for g=1:group
    r_s = Offsets{g};
    sum_EC = 0;
    sum_ED = 0;
    for i=1:row-block+1
        for j=1:col-block+1
            t = NL(i,j);    %噪声水平
            max = MAX(i,j); %预测内容的最大值
            min = MIN(i,j); %预测内容的最小值     
            rt = r_s(1,t+1);%最小值的补偿参数   
            st = r_s(2,t+1);%最大值的补偿参数 
            if I(i,j)-min == rt || I(i,j)-max == st
                sum_EC = sum_EC+1;
                sum_ED = sum_ED+0.5;
            elseif I(i,j)-min < rt || I(i,j)-max > st
                sum_ED = sum_ED+1;
            end      
        end
    end
    EC(g) = sum_EC;
    ED(g) = sum_ED;
end
%% 求54组中的最优补偿参数
ED_EC = inf; %记录最小失真嵌入比
index = -1; %表示存储容量不够
for g=1:group
    temp = ED(g)/EC(g);
    if EC(g)>=PS && temp<ED_EC       
        ED_EC = temp;       
        index = g;
    end
end
end