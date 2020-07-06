function [recover_I,exD] = Extract(stego_I,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2)
% 输入：stego_I载密图像；  输出：recover_I恢复图像，exD提取数据
% 黑色块：S_Shadow压缩噪声水平参数，Opt_Shadow最优嵌入参数，map1溢出信息，(end_x1,end_y1)结束位置
% 白色块：S_Blank压缩噪声水平参数，Opt_Blank最优嵌入参数，map2溢出信息，(end_x2,end_y2)结束位置

%% 再在(1,2)位置开始的白色菱形区域提取信息
[recover_I1,exD1] = Extract_Blank(stego_I,S_Blank,Opt_Blank,map2,end_x2,end_y2);
%% 再在(1,1)位置开始的黑色菱形区域提取信息
[recover_I2,exD2] = Extract_Shadow(recover_I1,S_Shadow,Opt_Shadow,map1,end_x1,end_y1);
%% 记录嵌入数据
recover_I = recover_I2;
exD = [exD2,exD1];
end