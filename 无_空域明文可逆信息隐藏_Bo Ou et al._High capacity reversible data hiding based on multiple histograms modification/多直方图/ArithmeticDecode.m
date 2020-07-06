function [ori_map] = ArithmeticDecode(map)
% map算术编码压缩后的二进制序列，ori_map原始二进制序列
% str = num2str(map); %将数组转换为字符串
% num = bin2dec(str); %将二进制字符串转换为十进制
map_2 = zeros();
n = 0;
a = 0;
b = 1;
while(map ~= a) 
    c = (b-a)*0.5; 
    if map >= a && map <c
        n = n+1;
        map_2(n) = 0;
        b = b-c;
    else
        n = n+1;
        map_2(n) = 1;
        a = a+c;
    end 
end
if map == a
    c = (b-a)*0.5;   
    if map >= a && map <c    
        n = n+1;    
        map_2(n) = 0;    
    else   
        n = n+1;
        map_2(n) = 1;   
    end 
end
%% 将二进制转换成十进制
num = floor(n/18);
ori_map = zeros(1,num);
for i=1:num
    s = 0;
    for j=1:18
        s = s + map_2((i-1)*18+j)*(2^(18-j));
    end
    ori_map(i) = s;
end