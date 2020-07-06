function P=GetDifferenceImage(I)
[row,col]=size(I);
P=zeros(row,col-1);
for i=1:row
    for j=1:col-1
        P(i,j)=max(I(i,j),I(i,j+1))-min(I(i,j),I(i,j+1));
    end
end
P=uint8(P);