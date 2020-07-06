function [Offsets] = Offset_Manners(r_s)
% 函数说明：生成54组补偿参数
% 输入：初始化补偿参数
% 输出：54组补偿参数
Offsets = cell(0);
num = 0; %计数
for i=-4:+1:31 %表示交叉位置 
    if mod(i,2) == 0 %偶数只有一种情况
        r_s_0 = r_s;        
        for j=0:31  %只考虑前32个直方图
            if i>=0 && j>=i+1
                r_s_0(1,j+1) = floor(i/2);   
                r_s_0(2,j+1) = -floor(i/2);
            elseif i<0 && j>=i+1
                r_s_0(1,j+1) = floor(i/2);   
                r_s_0(2,j+1) = -floor(i/2);
            end
        end   
        num = num+1;
        Offsets{num} = r_s_0;
    elseif mod(i,2) == 1 %奇数有两种情况
        r_s_1 = r_s;
        r_s_2 = r_s;
        for j=0:31  %只考虑前32个直方图
            if i>=0 && j>=i+1
                r_s_1(1,j+1) = floor(i/2)+1;
                r_s_1(2,j+1) = -floor(i/2);  
                r_s_2(1,j+1) = floor(i/2);
                r_s_2(2,j+1) = -floor(i/2)-1;
            elseif i<0 && j>=i+1
                r_s_1(1,j+1) = floor(i/2)+1;
                r_s_1(2,j+1) = -floor(i/2);  
                r_s_2(1,j+1) = floor(i/2);
                r_s_2(2,j+1) = -floor(i/2)-1;
            end
        end   
        num = num+1;
        Offsets{num} = r_s_1;
        num = num+1;
        Offsets{num} = r_s_2;
    end
end