function [U] = Context_Pixels(I,context,x_I,y_I)
% 函数说明：根据预测内容个数求得预测像素
% 输入：I（图像矩阵）,context（预测像素个数）,(x_I,y_I)（所求像素坐标）
% 输出：U（(x_I,y_I)处像素的预测像素）
block = ceil(sqrt(context+1)); %分块大小(开根号向上取整)
all_U = zeros();
if block == 2
    all_U(1) = I(x_I,y_I+1);
    all_U(2) = I(x_I+1,y_I);
    all_U(3) = I(x_I+1,y_I+1);
elseif block == 3
    all_U(1) = I(x_I,y_I+1);
    all_U(2) = I(x_I+1,y_I);
    all_U(3) = I(x_I+1,y_I+1);
    all_U(4) = I(x_I,y_I+2);
    all_U(5) = I(x_I+2,y_I);
    all_U(6) = I(x_I+1,y_I+2);
    all_U(7) = I(x_I+2,y_I+1);
    all_U(8) = I(x_I+2,y_I+2);
elseif block == 4
    all_U(1) = I(x_I,y_I+1);
    all_U(2) = I(x_I+1,y_I);
    all_U(3) = I(x_I+1,y_I+1);
    all_U(4) = I(x_I,y_I+2);
    all_U(5) = I(x_I+2,y_I);
    all_U(6) = I(x_I+1,y_I+2);
    all_U(7) = I(x_I+2,y_I+1);
    all_U(8) = I(x_I+2,y_I+2); 
    all_U(9) = I(x_I,y_I+3); 
    all_U(10) = I(x_I+3,y_I);
    all_U(11) = I(x_I+1,y_I+3);
    all_U(12) = I(x_I+3,y_I+1);
    all_U(13) = I(x_I+2,y_I+3);
    all_U(14) = I(x_I+3,y_I+2);
    all_U(15) = I(x_I+3,y_I+3);
end
U = all_U(1:context);
end