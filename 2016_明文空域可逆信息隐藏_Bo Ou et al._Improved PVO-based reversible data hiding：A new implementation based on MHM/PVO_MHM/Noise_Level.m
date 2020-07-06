function [NL,MAX,MIN] = Noise_Level(I,context)
% 函数说明：根据预测内容求图像I中每个像素的噪声水平以及预测内容的最大值和最小值
% 输入：I（图像矩阵）,context（预测像素个数）
% 输出：NL（噪声水平）,MAX（预测内容的最大值）,MIN（预测内容的最小值）
[row,col] = size(I);
block = ceil(sqrt(context+1)); %分块大小(开根号向上取整)
NL = I;
MAX = I;
MIN = I;
for i=1:row-block+1
    for j=1:col-block+1 
        [U] = Context_Pixels(I,context,i,j); %求当前像素的预测内容
        max_U = max(U); %最大值
        min_U = min(U); %最小值
        nl = max_U - min_U; %噪声水平
        NL(i,j) = nl;
        MAX(i,j) = max_U;
        MIN(i,j) = min_U;
    end
end  