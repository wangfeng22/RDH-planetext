function P=GetHistogram(I)                                                 
[row,col]=size(I);
A=zeros(1,256);
for i=1:row
    for j=1:col
        A(I(i,j)+1)=A(I(i,j)+1)+1;
    end
end
P=A;

