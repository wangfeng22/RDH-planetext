function [I1,lx]=embed(I,data,pixelnum)
[row,col]=size(I);
I1=I;
PE=GetPE(I1);
lend=1;
flag=0;
j=1;
while(j<=col)
    i=flag+1;
    while(i<=row)
        a=PE(i,j);
        b=PE(i+2,j);
        if a>=0 && b>=0
            if a==0 && b==0
                if data(lend)==1 && data(lend+1)==0
                    a=0;
                    b=1;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=1;
                    b=0;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==1 && b==1
                a=a+data(lend);
                b=b+data(lend);
                lend=lend+1;
            elseif a==0 && b>0
                a=a+data(lend);
                b=b+1;
                lend=lend+1;
            elseif a>0 && b==0
                a=a+1;
                b=b+data(lend);
                lend=lend+1;
            elseif a>0 && b>0
                a=a+1;
                b=b+1;
            end
        elseif a<0 && b>=0
            if a==-1 && b==0
                if data(lend)==1 && data(lend+1)==0
                    a=-1;
                    b=1;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=-2;
                    b=0;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==-2 && b==1
                a=a-data(lend);
                b=b+data(lend);
                lend=lend+1;
            elseif a==-1 && b>0
                a=a-data(lend);
                b=b+1;
                lend=lend+1;
            elseif a<-1 && b==0
                a=a-1;
                b=b+data(lend);
                lend=lend+1;
            elseif a<-1 && b>0
                a=a-1;
                b=b+1;
            end
        elseif a<0 && b<0
            if a==-1 && b==-1
                if data(lend)==1 && data(lend+1)==0
                    a=-1;
                    b=-2;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=-2;
                    b=-1;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==-2 && b==-2
                a=a-data(lend);
                b=b-data(lend);
                lend=lend+1;
            elseif a==-1 && b<-1
                a=a-data(lend);
                b=b-1;
                lend=lend+1;
            elseif a<-1 && b==-1
                a=a-1;
                b=b-data(lend);
                lend=lend+1;
            elseif a<-1 && b<-1
                a=a-1;
                b=b-1;
            end
        elseif a>=0 &&b<0
            if a==0 && b==-1
                if data(lend)==1 && data(lend+1)==0
                    a=0;
                    b=-2;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=1;
                    b=-1;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==1 && b==-2
                a=a+data(lend);
                b=b-data(lend);
                lend=lend+1;
            elseif a==0 && b<-1
                a=a+data(lend);
                b=b-1;
                lend=lend+1;
            elseif a>0 && b==-1
                a=a+1;
                b=b-data(lend);
                lend=lend+1;
            elseif a>0 && b<-1
                a=a+1;
                b=b-1;
            end
        end
        I1(i,j)=I(i,j)-PE(i,j)+a;
        I1(i+2,j)=I(i+2,j)-PE(i+2,j)+b;
        if lend>pixelnum
            break;
        end
        i=i+4;
    end
    if lend>pixelnum
         break;
    end
    j=j+1;
    flag=1-flag;
end
lx=lend;
if lx<=pixelnum
    PE=GetPE(I1);
    flag=1;
    j=1;
 while(j<=col)
    i=flag+1;
    while(i<=row)
        a=PE(i,j);
        b=PE(i+2,j);
        if a>=0 && b>=0
            if a==0 && b==0
                if data(lend)==1 && data(lend+1)==0
                    a=0;
                    b=1;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=1;
                    b=0;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==1 && b==1
                a=a+data(lend);
                b=b+data(lend);
                lend=lend+1;
            elseif a==0 && b>0
                a=a+data(lend);
                b=b+1;
                lend=lend+1;
            elseif a>0 && b==0
                a=a+1;
                b=b+data(lend);
                lend=lend+1;
            elseif a>0 && b>0
                a=a+1;
                b=b+1;
            end
        elseif a<0 && b>=0
            if a==-1 && b==0
                if data(lend)==1 && data(lend+1)==0
                    a=-1;
                    b=1;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=-2;
                    b=0;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==-2 && b==1
                a=a-data(lend);
                b=b+data(lend);
                lend=lend+1;
            elseif a==-1 && b>0
                a=a-data(lend);
                b=b+1;
                lend=lend+1;
            elseif a<-1 && b==0
                a=a-1;
                b=b+data(lend);
                lend=lend+1;
            elseif a<-1 && b>0
                a=a-1;
                b=b+1;
            end
        elseif a<0 && b<0
            if a==-1 && b==-1
                if data(lend)==1 && data(lend+1)==0
                    a=-1;
                    b=-2;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=-2;
                    b=-1;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==-2 && b==-2
                a=a-data(lend);
                b=b-data(lend);
                lend=lend+1;
            elseif a==-1 && b<-1
                a=a-data(lend);
                b=b-1;
                lend=lend+1;
            elseif a<-1 && b==-1
                a=a-1;
                b=b-data(lend);
                lend=lend+1;
            elseif a<-1 && b<-1
                a=a-1;
                b=b-1;
            end
        elseif a>=0 &&b<0
            if a==0 && b==-1
                if data(lend)==1 && data(lend+1)==0
                    a=0;
                    b=-2;
                    lend=lend+2;
                elseif data(lend)==1 && data(lend+1)==1
                    a=1;
                    b=-1;
                    lend=lend+1;
                elseif data(lend)==0
                    lend=lend+1;
                end
            elseif a==1 && b==-2
                a=a+data(lend);
                b=b-data(lend);
                lend=lend+1;
            elseif a==0 && b<-1
                a=a+data(lend);
                b=b-1;
                lend=lend+1;
            elseif a>0 && b==-1
                a=a+1;
                b=b-data(lend);
                lend=lend+1;
            elseif a>0 && b<-1
                a=a+1;
                b=b-1;
            end
        end
        I1(i,j)=I(i,j)-PE(i,j)+a;
        I1(i+2,j)=I(i+2,j)-PE(i+2,j)+b;
        if lend>pixelnum
            break;
        end
        i=i+4;
    end
    if lend>pixelnum
         break;
    end
    j=j+1;
    flag=1-flag;
 end
end
