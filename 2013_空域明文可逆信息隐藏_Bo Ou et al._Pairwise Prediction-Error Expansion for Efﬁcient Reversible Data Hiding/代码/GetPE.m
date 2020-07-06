function P=GetPE(I)
[row,col]=size(I);
for i=1:row
    for j=1:col
        num=0;
        sum=0;
        if i>1
            num=num+1;
            sum=sum+I(i-1,j);
        end
        if i<row
            num=num+1;
            sum=sum+I(i+1,j);
        end
        if j>1
            num=num+1;
            sum=sum+I(i,j-1);
        end
        if j<col
            num=num+1;
            sum=sum+I(i,j+1);
        end
        pe=floor(sum/num);
        P(i,j)=I(i,j)-pe;
    end
end