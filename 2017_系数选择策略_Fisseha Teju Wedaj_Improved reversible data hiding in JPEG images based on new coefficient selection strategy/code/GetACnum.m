function [ACnum]=GetACnum(Blockdct)
ACnum=zeros(63,2);
for count=1:63
    for r=1:64
        for c=1:64
            if Blockdct{r,c}(count+1)==1 || Blockdct{r,c}(count+1)==-1
                ACnum(count,1)=ACnum(count,1)+1;
            else if Blockdct{r,c}(count+1)>1 || Blockdct{r,c}(count+1)<-1
                    ACnum(count,2)=ACnum(count,2)+1;
                end
            end
        end
    end
end
end