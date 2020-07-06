function P=RemoveStep3(SD,W,lsum,A,B)
P=SD;
for i=1:lsum
    for r=1:A
        for c=1:B-1
            if SD(i,r,c)>W(i)
                SD(i,r,c)=SD(i,r,c)-1;
            end
        end
    end
end
P=SD;