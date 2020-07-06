function [R]=GetR(Blockdct,quant_tables)
R=zeros(63,2);
for count=1:63
    R(count,1)=count;
    for r=1:64
        for c=1:64
            if Blockdct{r,c}(count+1)==1 || Blockdct{r,c}(count+1)==-1
                a=1;
            else a=0;
            end
            if Blockdct{r,c}(count+1)>1 || Blockdct{r,c}(count+1)<-1
                b=1;
            else b=0;
            end
            if a==0 && b==0
                continue;
            end
            R(count,2)=R(count,2)+a/((b+a/2)*quant_tables(count+1)*quant_tables(count+1));
        end
    end
end
R=sortrows(R,-2);
end