function [maxy] = Blo(I1)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明;
maxx=0;
xx=I1(2,2);
for x=0:1:100%找出一个x使得R函数达到最大，x为预测值
    A=zeros(3);
    I1(2,2)=x;
    for i=0:2
        for j=0:2
            A(i+1,j+1)=cos(pi*(j+0.5)*i/3);
        end
    end
    f=A*I1*A';
    res=R(f);
    if maxx<res
        maxx=res;
        maxy=x;
    end
end
end

