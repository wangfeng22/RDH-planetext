function [P,endx,endy]=embed(I,PE,data,pixelnum)
P=I;
lend=1;
[row,col]=size(I);
for i=1:row-1
    for j=1:col-1
        if PE(i,j)<-1
            P(i,j)=P(i,j)-1;
        elseif PE(i,j)==-1
            P(i,j)=P(i,j)-1+data(lend);
            lend=lend+1;
        elseif PE(i,j)==0
            P(i,j)=P(i,j)+0+data(lend);
            lend=lend+1;
        elseif PE(i,j)>=1
            P(i,j)=P(i,j)+1;
        end
        if lend>pixelnum
            endx=i;
            endy=j;
            break;
        end
    end
    if lend>pixelnum
        endx=i;
        endy=j;
        break;
    end
end