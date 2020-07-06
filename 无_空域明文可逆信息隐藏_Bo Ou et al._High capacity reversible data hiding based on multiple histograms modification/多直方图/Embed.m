function [stego_I,emD,S_Shadow,Opt_Shadow,map1,end_x1,end_y1,S_Blank,Opt_Blank,map2,end_x2,end_y2] = Embed(origin_I,D)
%origin_I表示原始图像，D表示秘密数据，stego_I表示载密图像，emD表示已嵌入的数据
% num_emD = 0; %计数,记录嵌入数据个数
% [m,n] = size(origin_I); %统计stego_I的行列数

%菱形预测，分两层嵌入信息
num_D = length(D); %统计秘密数据个数
half = floor(num_D/2);
D1 = D(1:half);
D2 = D(half+1:num_D);
%% 先在(1,1)位置开始的黑色菱形区域嵌入信息
[stego_I1,emD1,S_Shadow,Opt_Shadow,map1,end_x1,end_y1] = Embed_Shadow(origin_I,D1);
%% 再在(1,2)位置开始的白色菱形区域嵌入信息
[stego_I2,emD2,S_Blank,Opt_Blank,map2,end_x2,end_y2] = Embed_Blank(stego_I1,D2);
%% 记录嵌入数据
stego_I = stego_I2;
emD = [emD1,emD2];
end