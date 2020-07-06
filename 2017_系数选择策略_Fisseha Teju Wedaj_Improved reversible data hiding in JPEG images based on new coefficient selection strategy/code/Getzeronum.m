function [zeronum]=Getzeronum(Blockdct)
zeronum=zeros(64*64,3);
count=1;
for r=1:64
    for c=1:64
        zeronum(count,1)=r;
        zeronum(count,2)=c;
        zeronum(count,3)=sum(Blockdct{r,c}(:)==0);
        count=count+1;
    end
end
zeronum=sortrows(zeronum,-3);
end