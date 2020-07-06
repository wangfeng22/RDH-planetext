function [height, width] = fun_read_sof_wh(a,z)
%提取SOF(Start Of Frame)，并提取图像的长宽
b=find(z(a+1)==192);
b=b(length(b),1);
c=a(b,1); %255，标记坐标
height = z(c+5:c+6, 1);
width = z(c+7:c+8, 1);
end
