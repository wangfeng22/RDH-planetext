function [payload,Cv,exchange_table]=Extside(side)
%函数功能：从边信息中提取payload,Cv,exchange_table

a=side(1:18);
a=num2str(a);
payload=bin2dec(a);

b=side(19:24);
b=num2str(b);
Cv=bin2dec(b);

exchange_table=side(25:56);


