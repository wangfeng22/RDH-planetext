%算法：根据输入的RLE，构造其AC系数阵
function reAC=RecoveryRLE(RLE)
reAC=zeros(63,1);
[m,~]=size(RLE);
cnt=1;
for i=1:m;
    r=RLE(i,1);
    v=RLE(i,2);
    for j=1:r;
        reAC(cnt)=0;
        cnt=cnt+1;
    end
    reAC(cnt)=v;
    cnt=cnt+1;
end
end