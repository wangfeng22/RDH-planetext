function [context,Offsets,index,opt_R_S,NL,MAX,MIN] = Optimal(I,PS,context)
% 函数说明：求最优产参数，包括预测像素个数和补偿参数
% 输入：I（图像矩阵）,PS（需要的嵌入容量）,context（预测像素个数）
% 输出：context（修改的预测像素个数）,Offsets（54组补偿参数）,index（最优补偿参数的索引）,opt_R_S（优化参数）,NL（噪声水平）,MAX（预测内容的最大值）,MIN（预测内容的最小值）
% I = change_ori_I;
%% 计算修正图像的噪声水平以及预测内容的最大值和最小值
[NL,MAX,MIN] = Noise_Level(I,context);
%% 初始化补偿参数
r_s = zeros(2,256); %初始化全为0,共有256个直方图
r_s(1,1) = -1;
[Offsets] = Offset_Manners(r_s);
%% 求解54组补偿参数的最优一组补偿参数
[index] = Offset_Select(I,context,NL,MAX,MIN,Offsets,PS);
%% 参数优化
if index~=-1
    R_S = Offsets{index};
    [opt_R_S] = Offset_Optimize(I,context,NL,MAX,MIN,R_S,PS);
elseif index==-1 && context>2
    context = context-1;
    [context,Offsets,index,opt_R_S,NL,MAX,MIN] = Optimal(I,PS,context);
else
    disp('超过最大嵌入容量!');
end
end