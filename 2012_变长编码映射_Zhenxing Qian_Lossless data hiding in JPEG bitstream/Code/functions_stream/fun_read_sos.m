function y= fun_read_sos( a,z,f )
%a 文件中所有255所在行
%z 文件机器码
%y为sos段除标记等未处理的图片数据压缩部分
b=find(z(a+1)==218);
c=a(b,1); %255，标记坐标
d=z((c+2),1)*16*16+z((c+3),1);  %各标记字节长度
e=find(z(a+1)==217);
g=a(e,1)-c(1,1)-d(1,1)-2;  %255(217)-255(218)-217段长度-217标记长度
status=fseek(f,c+d+1,'bof');
y=fread(f,g,'uint8');

end

