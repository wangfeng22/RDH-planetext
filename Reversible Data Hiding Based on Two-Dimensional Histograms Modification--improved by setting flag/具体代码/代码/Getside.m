function [side]=Getside(payload,Cv,exchange_table)  
%函数功能：将辅助信息化为二进制序列

side=zeros(1,56);
%data = num2bin(face);%将待嵌入数据转换成二进制形式
%data = strcat(char(data)', '');%将其转换成字符数组
% data = cellstr(data)';
%data = str2num(data(:));%将其转换成整数数组
% Cv>=1 && Cv<=32

a = num2bin(quantizer([19 0]),payload);    %paylaod即载荷，用18位二进制序列表示
a=strcat(char(a)','');     
a=str2num(a(:));
side(1:18)=a(2:19);

b= num2bin(quantizer([7 0]),Cv);     %Cv，用6位二进制序列表示
b=strcat(char(b)','');     
b=str2num(b(:));
side(19:24)=b(2:7);

side(25:56)=exchange_table;

end
