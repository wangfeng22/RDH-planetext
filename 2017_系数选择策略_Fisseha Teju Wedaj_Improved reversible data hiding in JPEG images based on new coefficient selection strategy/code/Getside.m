function [side]=Getside(payload,positions)
side=zeros(1,81);
%data = dec2bin(face);%将待嵌入数据转换成二进制形式
%data = strcat(char(data)', '');%将其转换成字符数组
% data = cellstr(data)';
%data = str2num(data(:));%将其转换成整数数组

b = num2bin(quantizer([18 0]),payload);
b=strcat(char(b)','');
b=str2num(b(:));
side(1:18)=b;
len=length(positions);
for i=1:len
    side(positions(i)+18)=1;
end
end