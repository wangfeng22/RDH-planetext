function [hist_ac1,num1,num_1] = jpeg_hist(dct_coef) %绘制ac系数直方图
%num1表示ac系数值为1的数量,num_1表示ac系数值为-1的数量
[m,n] = size(dct_coef); %统计dct系数的行列数
ac_1 = zeros(); %存储非零ac系数
t1 = 0;
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数
            if dct_coef(i,j) ~= 0 %遍历ac系数为0时
                t1 = t1 + 1;
                ac_1(t1) = dct_coef(i,j);            
            end
        end
    end
end
hist_ac1=tabulate(ac_1(:)); %统计非零ac系数直方图
num1 = hist_ac1((hist_ac1(:,1)==1),2);
num_1 = hist_ac1((hist_ac1(:,1)==-1),2);
end
