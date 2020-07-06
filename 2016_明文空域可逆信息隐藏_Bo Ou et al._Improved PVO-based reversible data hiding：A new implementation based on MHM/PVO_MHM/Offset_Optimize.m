function [opt_R_S] = Offset_Optimize(I,context,NL,MAX,MIN,R_S,PS)
% 函数说明：对补偿参数进一步优化
% 输入：I（图像矩阵）,context（预测像素个数）,NL（噪声水平）,MAX（预测内容的最大值）,MIN（预测内容的最小值）,R_S（原来的补偿参数）,PS（需要的嵌入容量）
% 输出：opt_R_S（优化参数）
opt_R_S = zeros(2,32);
[row,col] = size(I);
block = ceil(sqrt(context+1)); %分块大小(开根号向上取整)
for h=1:32
    ED_EC = inf; %记录最小失真嵌入比
    for vr=-2:+1:1
        for vs=-2:+1:1
            sum_EC = 0;
            sum_ED = 0;
            for i=1:row-block+1
                for j=1:col-block+1
                    t = NL(i,j); %噪声水平
                    max = MAX(i,j); %预测内容的最大值
                    min = MIN(i,j); %预测内容的最小值 
                    rt = R_S(1,t+1);%最小值的补偿参数           
                    st = R_S(2,t+1);%最大值的补偿参数
                    if t < h-1 %修正参数
                        rt = rt + opt_R_S(1,t+1);
                        st = st + opt_R_S(2,t+1);
                    elseif t == h-1
                        rt = rt + vr; 
                        st = st + vs; 
                    end
                    if I(i,j)-min == rt || I(i,j)-max == st 
                        sum_EC = sum_EC+1; 
                        sum_ED = sum_ED+0.5;
                    elseif I(i,j)-min < rt || I(i,j)-max > st
                        sum_ED = sum_ED+1;
                    end  
                end
            end
            temp = sum_ED/sum_EC;
            if temp<ED_EC && sum_EC>=PS
                ED_EC = temp;
                opt_R_S(1,h) = vr;
                opt_R_S(2,h) = vs;
            end
        end
    end
end
opt_R_S = opt_R_S(1:2,1:32); %只取前32个直方图的参数
end