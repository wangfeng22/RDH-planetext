function [min_Cv]=minimum_Cv(stego_blockdct,data,zeronum)   
%函数功能：找到能满足嵌入容量的最小Cv

pos=0;
count=1;
payload=length(data);
stego_blockdct_2=stego_blockdct;
flag=0;

%Cv从小到大进行模拟嵌入，如果能满足嵌入容量则跳出循环
for min_Cv=2:32         
    while pos<payload && count<=4096
    [stego_blockdct_2,pos]=embed(stego_blockdct_2,data,pos,zeronum(count,1),zeronum(count,2),min_Cv);     %嵌入，返回值stego_blockdct_2为嵌入后的dct矩阵，返回值pos表示已嵌入多少数据
    count=count+1;
    end
    if pos>=payload && count<=4097                   %容量满足，跳出循环
        flag=1;
        break
    end
    stego_blockdct_2=stego_blockdct;
    pos=0;
    count=1;
end

if flag==0
    fprintf('容量不够！\n');
end

end
