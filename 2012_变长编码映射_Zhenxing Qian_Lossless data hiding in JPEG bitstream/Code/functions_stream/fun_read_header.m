function y= fun_read_header(a,z)
%提取文件头，转换16进制，调整16个字节成一行方便显示
b=find(z(a+1)==218);%定位扫描行(SOS)FFDA的位置
b=b(length(b),1);
c=a(b,1); %255，标记坐标
d=z((c+2),1)*16*16+z((c+3),1);  %各标记字节长度
y=z(1:c+1+d,1);%文件头的二进制
end
