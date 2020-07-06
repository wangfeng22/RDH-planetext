function [a, m]= fun_dlt_soi(a)
%输入y为sos段除标记等未处理的图片数据压缩部分
%输出y为去掉255之后SOI的图片数据压缩部分
s = [1;0;1;0; 1;1;1;1;1;1;1;1; 1;1;0;1; 1;0;0;1];
for i = 1:length(a)-19
    if(a(i:i+19)==s)
        m = i + 4;
        for k = i+4:length(a)-16
            a(k) = a(k+16);
        end
        break;
    end
end
a = a(1:length(a)-16);
end