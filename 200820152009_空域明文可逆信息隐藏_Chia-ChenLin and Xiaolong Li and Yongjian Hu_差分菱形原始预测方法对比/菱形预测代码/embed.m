function [I2,end1,flg]=embed(I1,data,pixelnum)
I1=double(I1);
I2=I1;
[P,PE]=RhombusPredictionValue(I2);
[row,col]=size(I2);
 j=1;
 lend=1;
 end1=0;
 flg=0;
 sign=0;
 while(j<=col)
     i=sign+1;
      while(i<=row)
        e=PE(i,j);
        if e>0
            e=e+1;
        elseif e<-1
            e=e-1;
        elseif e==0
            e=e+data(1,lend);
            lend=lend+1;
        elseif e==-1
            e=e-data(1,lend);
            lend=lend+1;
        end
        I2(i,j)=P(i,j)+e;
        if lend>pixelnum
            break;
        end
        i=i+2;
     end
     if lend>pixelnum
             break;
     end
     j=j+1;
     sign=1-sign;
 end
 end1=lend;
 if lend<=pixelnum
     sign=1;
     j=1;
     flg=1;
     [P,PE]=RhombusPredictionValue(I2);
     while(j<=col)
         i=sign+1;
         while(i<=row)
          e=PE(i,j);
          if e>0
            e=e+1;
          elseif e<-1
            e=e-1;
          elseif e==0
            e=e+data(1,lend);
            lend=lend+1;
          elseif e==-1
            e=e-data(1,lend);
            lend=lend+1;
          end
          I2(i,j)=P(i,j)+e;
          i=i+2;
         if lend>pixelnum
            break;
         end
        end
         if lend>pixelnum
                 break;
         end
         sign=1-sign;
         j=j+1;
     end
 end