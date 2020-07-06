function [R]=GetR(quant_tables)
%函数功能：对32个位置进行优先级排序
%每个位置，有两个量化因子，我们取他们的平均值的倒数，这个值越大，优先级越高
R=zeros(32,2);
Z_qtable=GetZigzag(quant_tables);
for count=1:32
   R(count,1)=count;
   R(count,2)=2/(Z_qtable(1,2*count-1)+Z_qtable(1,2*count));
end
R=sortrows(R,-2);     %按第二列降序整理行
   
   