function [map,com_map] = LocationMap(I,Noise,Opt)
% I表示原始图像，Noise表示I的压缩噪声，Opt表示最优参数
[row,col]=size(I);
map = zeros();
num = 0; %计数
for i=2:row-2 %行
    for j=2:col-2 %列
        if Noise(i,j) ~= -1 % -1表示暂时不用的部分
            n = Noise(i,j); %属于哪个直方图
            a = Opt(1,n);  %第n个直方图的嵌入对数
            if I(i,j) <= a-1 ||  I(i,j) > 255-a  %平移或嵌入之后会溢出
                num = num + 1;
                map(num) = (i-1)*512+j; %记录溢出快位置信息
            end
%             num = num + 1;
%             if I(i,j) <= a-1 ||  I(i,j) > 255-a  %平移或嵌入之后会溢出
%                 map(num) = 1;  %1表示溢出
%             else
%                 map(num) = 0;
%             end
        end
    end
end
[com_map] = ArithmeticEncode(map);
end