function [P,E] = GetPE(I)
%DHS预测在上次得到的预测图像上进行
I=double(I);
PP=I;
[row,col]=size(PP);
    for i=2:2:row-2
        for j=2:2:col-2
            PP(i,j)=(I(i,j-1)+I(i,j+1)+I(i+1,j)+I(i-1,j))/4;
        end
    end
    P=PP;
    for i=2:2:row-2
        for j=3:2:col-1
            P(i,j)=(PP(i,j-1)+PP(i,j+1)+PP(i+1,j)+PP(i-1,j))/4;
        end
    end
    for i=3:2:row-1
        for j=2:1:col-1
                P(i,j)=(PP(i,j-1)+PP(i,j+1)+PP(i+1,j)+PP(i-1,j))/4;
        end
    end  
    E=I-P;
end
