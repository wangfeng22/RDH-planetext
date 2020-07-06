function [PExh,PExv,PE]=DirectionalPredictionValue(I)
[row,col]=size(I);
Pxh=I;
Pxv=I;
PExh=I;
PExv=I;
PE=I;
for i=1:row
    for j=1:col
        h=0;
        v=0;
        xh=0;
        xv=0;
        if i>1
            xv=xv+I(i-1,j);
            v=v+1;
        end
        if i<row
            xv=xv+I(i+1,j);
            v=v+1;
        end
        if j>1
            xh=xh+I(i,j-1);
            h=h+1;
        end
        if j<col
            xh=xh+I(i,j+1);
            h=h+1;
        end
        Pxh(i,j)=floor(double(xh)/double(h));
        Pxv(i,j)=floor(double(xv)/double(v));
        PExh(i,j)=I(i,j)-Pxh(i,j);
        PExv(i,j)=I(i,j)-Pxv(i,j);
        if(abs(PExh(i,j))<=abs(PExv(i,j)))
            PE(i,j)=PExh(i,j);
        else
            PE(i,j)=PExv(i,j);
        end
    end
end
            
