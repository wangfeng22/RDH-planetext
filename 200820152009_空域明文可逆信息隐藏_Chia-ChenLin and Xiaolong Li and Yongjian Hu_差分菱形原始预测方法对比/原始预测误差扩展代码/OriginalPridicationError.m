function P=OriginalPridicationError(I)
[row,col]=size(I);
P=I;
for i=1:row-1
    for j=1:col-1
        a=I(i,j+1);
        b=I(i+1,j+1);
        c=I(i+1,j);
        if b<=min(a,c)
            P(i,j)=max(a,c);
        elseif b>=max(a,c)
            P(i,j)=min(a,c);
        else
            P(i,j)=a+c-b;
        end
    end
end
P=I-P;
