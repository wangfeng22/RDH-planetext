function [zeronum]=Getzeronum(blockdct)    
%函数功能：统计每个块AC系数为0的数目（不含AC1）
%返回值zeronum------第一列为块的横坐标，第二列为块的纵坐标，第三列为块AC系数为0的数目
zeronum=zeros(64*64,3);        
count=1;
for r=1:64
    for c=1:64
        zeronum(count,1)=r;
        zeronum(count,2)=c;
        blockdct{r,c}(1,1:2)=99;              %排掉前两个系数
        zeronum(count,3)=sum(blockdct{r,c}(:)==0);
        count=count+1;
    end
end

end