function [diaPV_I,diaPE_I] = diamond(I) 
%diaPV_I表示预测值,diaPE_I表示预测误差
[row,col]=size(I);
diaPV_I = I;
diaPE_I = I;
for i=1:row
    for j=1:col
        num=0;
        sum=0;
        if i>1 %第一行前面没有像素
            sum=sum+I(i-1,j);
            num=num+1;
        end
        if j>1 %第一列前面没有像素
            sum=sum+I(i,j-1);
            num=num+1;
        end
        if i<row %最后一行后面没有像素
            sum=sum+I(i+1,j);
            num=num+1;
        end
        if j<col %最后一列后面没有像素
            sum=sum+I(i,j+1);
            num=num+1;
        end
        diaPV_I(i,j) = floor(sum/num);
        diaPE_I(i,j) = I(i,j)-diaPV_I(i,j);
    end
end