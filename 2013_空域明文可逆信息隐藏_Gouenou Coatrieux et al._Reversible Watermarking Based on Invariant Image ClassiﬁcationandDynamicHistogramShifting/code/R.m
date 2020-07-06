function [res] = R(f)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
d=f(:)';
d=sort(d,'descend');
d1=d.^2;
sum1=sum(d1);
sum2=sum(d1(1:4));
res=sum2/sum1;
end

