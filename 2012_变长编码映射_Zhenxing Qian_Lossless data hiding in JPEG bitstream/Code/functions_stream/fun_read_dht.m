function y= fun_read_dht( a,z,f,num )
%提取文件头中得DHT段
b=find(z(a+1,1)==196);    %标记在a中行数数组
b=b(num,1);  %所需表标记在a中行数
c=a(b,1);  %255，标记坐标
d=z((c+2),1)*16*16+z((c+3),1);  %各标记字节长度
status=fseek(f,c-1,'bof');
y=fread(f,d+2,'uint8');
end

