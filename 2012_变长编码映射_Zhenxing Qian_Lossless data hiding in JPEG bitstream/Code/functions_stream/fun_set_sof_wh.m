function z = fun_set_sof_wh(a, z, height, width)
%在SOF(Start Of Frame)设置图像的长宽
b=find(z(a+1)==192);
b=b(length(b),1);
c=a(b,1); %255，标记坐标

%转换长、宽为2字节16进制数
h1 = fix(height/256);
h2 = height - h1*256;

w1 = fix(width/256);
w2 = width - w1*256;

%嵌入长、宽
z(c+5, 1) = h1;
z(c+6, 1) = h2;
z(c+7, 1) = w1;
z(c+8, 1) = w2;

end