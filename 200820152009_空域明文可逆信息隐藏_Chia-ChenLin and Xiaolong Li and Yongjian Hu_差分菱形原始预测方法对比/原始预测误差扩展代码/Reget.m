function [I2,rdata]=Reget(I1,pixelnum,endx,endy)
I2=I1;
I3=I1;
rdata=zeros(1,pixelnum);
[row,col]=size(I1);
lend=pixelnum;
flag=1;
i=endx;
while(i>0)
    j=col-1;
    if flag==1
        j=endy;
        flag=0;
    end
   while(j>0)
        x=I3(i,j);
        a=I3(i,j+1);
        b=I3(i+1,j+1);
        c=I3(i+1,j);
        pe=0;
        if b<=min(a,c)
            pe=max(a,c);
        elseif b>=max(a,c)
            pe=min(a,c);
        else
            pe=a+c-b;
        end
        pe=x-pe;
        if pe>=-2 && pe<2
            ppe=floor(abs(double(pe))/2);
            rdata(1,lend)=abs(pe)-ppe*2;
            if pe>=0
                ppe=floor(double(pe)/2);
            else
                ppe=-floor(abs(double(pe-1))/2);
            end
            I2(i,j)=x-ppe-rdata(lend);
            lend=lend-1;
        elseif pe>1
            I2(i,j)=I1(i,j)-1;
        elseif pe<-2
            I2(i,j)=I1(i,j)+1;
        end
        I3(i,j)=I2(i,j);
        j=j-1;
   end
   i=i-1;
end