function [com_map,map_2] = ArithmeticEncode(map)  %%小数太多，不方便计算
% map原始二进制序列，com_map算术编码压缩后的二进制序列
[~,num]=size(map);
if num == 1 && map(num) == 0
    com_map = 0;
else
    %% 位置信息转换成二进制序列
    map_2 = zeros(1,num*18);
    s = 0; %计数
    for i=1:num  %转换成二进制
        data = map(i);
        for j=18:-1:1 % 512*512图像每个像素的位置用18位二进制就可以表示
            map_2(s+j) = mod(data,2);
            data = floor(data/2);
        end
        s = s + 18;
    end
    %% 算术编码
    a = 0;
    b = 1;
    for i=1:num*18   
        if map_2(i) == 0
            c = (b-a)*0.5;   
            b = b-c;
            % c = roundn((b-a)*0.5,-100); %保留多位小数
            % b = roundn(b-c,-100);
        else  % map_2(i)==1
            c = (b-a)*0.5;
            a = a+c;
            % c = roundn((b-a)*0.5,-100);
            % a = roundn(a+c,-100);
        end  
    end 
    com_map = a;
end