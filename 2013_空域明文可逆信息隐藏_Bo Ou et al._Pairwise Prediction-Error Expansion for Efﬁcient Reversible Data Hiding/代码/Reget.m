function [I2,rdata]=Reget(I1,lx,pixelnum)
I2=I1;
[row,col]=size(I1);
rdata=zeros(1,pixelnum);
PE=GetPE(I2);
P=I1-PE;
if lx<=pixelnum
    lend=lx;
    j=1;
    flag=1;
    while(j<=col)
        i=flag+1;
        while(i<=row)
            a=PE(i,j);
            b=PE(i+2,j);
            if a>=0 && b>=0
                if a<=1 || b<=1
                    if a==1 && b==1
                        rdata(lend)=0;
                        lend=lend+1;
                    elseif a>=0 && b>1
                        rdata(lend)=a;
                        lend=lend+1;
                        a=0;
                        b=b-1;
                    elseif b>=0 && a>1
                        rdata(lend)=b;
                        lend=lend+1;
                        a=a-1;
                        b=0;
                    elseif a==0 && b==1
                        rdata(lend)=1;
                        rdata(lend+1)=0;
                        lend=lend+2;
                        a=0;
                        b=0;
                    else
                        rdata(lend)=a;
                        lend=lend+1;
                        a=0;
                    end
                elseif a==2 && b==2
                    rdata(lend)=1;
                    lend=lend+1;
                    a=1;
                    b=1;
                else
                    a=a-1;
                    b=b-1;
                end
            elseif a<0 && b>=0
                if a>=-2 || b<=1
                    if a==-2 && b==1
                        rdata(lend)=0;
                        lend=lend+1;
                    elseif a>=-2 && b>1
                        rdata(lend)=-1-a;
                        lend=lend+1;
                        a=-1;
                        b=b-1;
                    elseif a<-2 && b<=1
                        rdata(lend)=b;
                        lend=lend+1;
                        a=a+1;
                        b=0;
                    elseif a==-1 && b==1
                        rdata(lend)=1;
                        rdata(lend+1)=0;
                        lend=lend+2;
                        a=-1;
                        b=0;
                    else
                        rdata(lend)=-1-a;
                        lend=lend+1;
                        a=-1;
                    end
                elseif a==-3 && b==2
                    rdata(lend)=1;
                    lend=lend+1;
                    a=a+1;
                    b=b-1;
                else
                    a=a+1;
                    b=b-1;
                end
            elseif a<0 && b<0
                if a>=-2 || b>=-2
                    if a>=-2 && b<-2
                        rdata(lend)=-1-a;
                        lend=lend+1;
                        a=-1;
                        b=b+1;
                    elseif a<-2 && b>=-2
                        rdata(lend)=-1-b;
                        lend=lend+1;
                        a=a+1;
                        b=-1;
                    elseif a==-2 && b==-2
                        rdata(lend)=0;
                        lend=lend+1;
                    elseif a==-1 && b==-2
                        rdata(lend)=1;
                        rdata(lend+1)=0;
                        lend=lend+2;
                        b=-1;
                    else
                        rdata(lend)=-1-a;
                        lend=lend+1;
                        a=-1;
                    end
                elseif a==-3 && b==-3
                    rdata(lend)=1;
                    lend=lend+1;
                    a=-2;
                    b=-2;
                else
                    a=a+1;
                    b=b+1;
                end
            elseif a>=0 && b<0
                if a<=1 || b>=-2
                    if a==1 && b==-2
                        rdata(lend)=0;
                        lend=lend+1;
                    elseif a<=1 && b<-2
                        rdata(lend)=a;
                        lend=lend+1;
                        a=0;
                        b=b+1;
                    elseif a>1 && b>=-2
                        rdata(lend)=-1-b;
                        lend=lend+1;
                        b=-1;
                        a=a-1;
                    elseif a==0 && b==-2
                        rdata(lend)=1;
                        rdata(lend+1)=0;
                        lend=lend+2;
                        b=-1;
                    else
                        rdata(lend)=a;
                        lend=lend+1;
                        a=0;
                    end
                elseif a==2 && b==-3
                    rdata(lend)=1;
                    lend=lend+1;
                    a=1;
                    b=-2;
                else
                    a=a-1;
                    b=b+1;
                end
            end
            I2(i,j)=P(i,j)+a;
            I2(i+2,j)=P(i+2,j)+b;
            i=i+4;
            if lend>pixelnum
                break;
            end
        end
        if lend>pixelnum
                break;
        end
        j=j+1;
        flag=1-flag;
    end
end
lend=1;
flag=0;
PE=GetPE(I2);
P=I2-PE;
j=1;
while(j<=col)
    i=flag+1;
    while(i<=row)
        a=PE(i,j);
        b=PE(i+2,j);
        if a>=0 && b>=0
            if a<=1 || b<=1
                if a==1 && b==1
                    rdata(lend)=0;
                    lend=lend+1;
                elseif a>=0 && b>1
                    rdata(lend)=a;
                    lend=lend+1;
                    a=0;
                    b=b-1;
                elseif b>=0 && a>1
                    rdata(lend)=b;
                    lend=lend+1;
                    a=a-1;
                    b=0;
                elseif a==0 && b==1
                    rdata(lend)=1;
                    rdata(lend+1)=0;
                    lend=lend+2;
                    a=0;
                    b=0;
                else
                    rdata(lend)=a;
                    lend=lend+1;
                    a=0;
                end
            elseif a==2 && b==2
                rdata(lend)=1;
                lend=lend+1;
                a=1;
                b=1;
            else
                a=a-1;
                b=b-1;
            end
        elseif a<0 && b>=0
            if a>=-2 || b<=1
                if a==-2 && b==1
                    rdata(lend)=0;
                    lend=lend+1;
                elseif a>=-2 && b>1
                    rdata(lend)=-1-a;
                    lend=lend+1;
                    a=-1;
                    b=b-1;
                elseif a<-2 && b<=1
                    rdata(lend)=b;
                    lend=lend+1;
                    a=a+1;
                    b=0;
                elseif a==-1 && b==1
                    rdata(lend)=1;
                    rdata(lend+1)=0;
                    lend=lend+2;
                    a=-1;
                    b=0;
                else
                    rdata(lend)=-1-a;
                    lend=lend+1;
                    a=-1;
                end
            elseif a==-3 && b==2
                rdata(lend)=1;
                lend=lend+1;
                a=a+1;
                b=b-1;
            else
                a=a+1;
                b=b-1;
            end
        elseif a<0 && b<0
            if a>=-2 || b>=-2
                if a>=-2 && b<-2
                    rdata(lend)=-1-a;
                    lend=lend+1;
                    a=-1;
                    b=b+1;
                elseif a<-2 && b>=-2
                    rdata(lend)=-1-b;
                    lend=lend+1;
                    a=a+1;
                    b=-1;
                elseif a==-2 && b==-2
                    rdata(lend)=0;
                    lend=lend+1;
                elseif a==-1 && b==-2
                    rdata(lend)=1;
                    rdata(lend+1)=0;
                    lend=lend+2;
                    b=-1;
                else
                    rdata(lend)=-1-a;
                    lend=lend+1;
                    a=-1;
                end
            elseif a==-3 && b==-3
                rdata(lend)=1;
                lend=lend+1;
                a=-2;
                b=-2;
            else
                a=a+1;
                b=b+1;
            end
        elseif a>=0 && b<0
            if a<=1 || b>=-2
                if a==1 && b==-2
                    rdata(lend)=0;
                    lend=lend+1;
                elseif a<=1 && b<-2
                    rdata(lend)=a;
                    lend=lend+1;
                    a=0;
                    b=b+1;
                elseif a>1 && b>=-2
                    rdata(lend)=-1-b;
                    lend=lend+1;
                    b=-1;
                    a=a-1;
                elseif a==0 && b==-2
                    rdata(lend)=1;
                    rdata(lend+1)=0;
                    lend=lend+2;
                    b=-1;
                else
                    rdata(lend)=a;
                    lend=lend+1;
                    a=0;
                end
            elseif a==2 && b==-3
                rdata(lend)=1;
                lend=lend+1;
                a=1;
                b=-2;
            else
                a=a-1;
                b=b+1;
            end
        end
        I2(i,j)=P(i,j)+a;
        I2(i+2,j)=P(i+2,j)+b;
        i=i+4;
        if lend>pixelnum
            break;
        end
    end
    if lend>pixelnum
            break;
    end
    j=j+1;
    flag=1-flag;
end