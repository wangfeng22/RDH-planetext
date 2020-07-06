function [rdata,I2]=Rget(I1,step,side,lim)
rdata=int32(zeros(1,lim));
I2=I1;
[P,PE]=RhombusPredictionValue(I2);
[row,col]=size(I2);
lend=step;
j=1;
sign=1;
flag=0;
while(j<=col && side==1 && flag==0)
    i=sign+1;
    while(i<=row)
        e=PE(i,j);
        if e>1
            e=e-1;
        elseif e<-2
            e=e+1;
        elseif e>=0 && e<=1
            rdata(1,lend)=e;
            e=0;
            lend=lend+1;
        elseif e>=-2 && e<=-1;
            rdata(1,lend)=-1-e;
            e=-1;
            lend=lend+1;
        end
        I2(i,j)=P(i,j)+e;
        i=i+2;
        if lend>lim 
            flag=1;
            break;
        end
    end
    j=j+1;
    sign=1-sign;
end
% I4=get_pe(I3);
% I5=get_p(I3);
[P,PE]=RhombusPredictionValue(I2);
lend=1;
p=1;
j=1;
sign=0;
flag=0;
while(j<=col && flag==0)
    i=sign+1;
    while(i<=row)
        e=PE(i,j);
        if e>1
            e=e-1;
        elseif e<-2
            e=e+1;
        elseif e>=0 && e<=1
            rdata(1,lend)=e;
            e=0;
            lend=lend+1;
        elseif e>=-2 && e<=-1;
            rdata(1,lend)=-1-e;
            e=-1;
            lend=lend+1;
        end
        I2(i,j)=P(i,j)+e;
        i=i+2;
        if lend>lim 
            flag=1;
            break;
        end
    end
    j=j+1;
    sign=1-sign;
end
end

