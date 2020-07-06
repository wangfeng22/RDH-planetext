function [P,PE]=RhombusPredictionValue(I)
[row,col]=size(I);
P=I;
PE=I;
for i=1:row
    for j=1:col
        cc=0;
        sum=0;
        if i>1
            sum=sum+I(i-1,j);
            cc=cc+1;
        end
        if j>1
            sum=sum+I(i,j-1);
            cc=cc+1;
        end
        if i<row
            sum=sum+I(i+1,j);
            cc=cc+1;
        end
        if j<col
            sum=sum+I(i,j+1);
            cc=cc+1;
        end
        P(i,j)=floor(double(sum)/double(cc));
        PE(i,j)=I(i,j)-P(i,j);
    end
end
