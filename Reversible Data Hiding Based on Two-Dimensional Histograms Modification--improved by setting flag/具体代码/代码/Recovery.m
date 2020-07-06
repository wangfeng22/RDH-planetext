function [stego_blockdct]=Recovery(AC_matrix,zigzag)
zigzag_blockAC=cell(1,4096);
for i=1:4096
    r=2;c=1;
    a=zeros(8,8);
    a(1,1)=zigzag{1,i}(1,1);
    for j=1:63
        a(r,c)=AC_matrix(j,i);
        r=r+1;
        if r==9
           r=1;
           c=c+1;
        end
    end
    zigzag_blockAC{1,i}=a;
end
stego_blockdct = AntiZigzag(zigzag_blockAC);
end