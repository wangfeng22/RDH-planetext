function [Noise_Shadow,S_Shadow,Noise_Blank,S_Blank] = CompressNoise(Noise) 
% Noise原始噪声水平
%黑色块：Noise_Shadow压缩噪声水平，S_Shadow记录压缩划分区间
%白色块：Noise_Blank压缩噪声水平，S_Blank记录压缩划分区间
[m,n] = size(Noise);
M = 16; %将噪声水平压缩到范围:[1,16]
Noise_Shadow = Noise;
Noise_Blank = Noise;
%% 压缩黑色块的噪声水平
Max_Shadow = 0;
N_Shadow = 0; 
for i=2:m-2  %第一行+最后两行（不用）
    for j=2:n-2  %第一列+最后两列（不用）
       if mod((i+j),2)==0 %黑色块
           N_Shadow = N_Shadow+1; %记录黑色块噪声水平个数
           if Max_Shadow < Noise_Shadow(i,j)
               Max_Shadow = Noise_Shadow(i,j); %计算最大噪声水平
           end
       else
           Noise_Shadow(i,j) = -1; %不用部分标记为-1
       end 
    end
end
S_Shadow = zeros(1,M-1); %用来记录压缩划分区间
for v=0:M-2
    sum_Shadow = 0; %记录噪声水平≤Sn的个数
    for Sn=0:Max_Shadow
        for i=2:m-2     
            for j=2:n-2     
                if mod((i+j),2)==0 && Noise_Shadow(i,j)==Sn   
                    sum_Shadow = sum_Shadow+1;  
                end     
            end     
        end 
        if sum_Shadow/N_Shadow >= (v+1)/M
            S_Shadow(v+1) = Sn;
            break;
        else         
            continue;
        end
    end
end
for v=1:M  %范围压缩
    for i=2:m-2           
        for j=2:n-2
            if v == 1
                if Noise_Shadow(i,j)>=0 && Noise_Shadow(i,j)<=S_Shadow(v)
                    Noise_Shadow(i,j) = v;
                end
            elseif v == M
                if Noise_Shadow(i,j)>=S_Shadow(v-1)+1
                    Noise_Shadow(i,j) = v;
                end
            else
                if Noise_Shadow(i,j)>=S_Shadow(v-1)+1 && Noise_Shadow(i,j)<=S_Shadow(v)
                    Noise_Shadow(i,j) = v;
                end
            end
        end
    end
end
%% 压缩白色块的噪声水平
Max_Blank = 0;
N_Blank = 0; 
for i=2:m-2  %第一行+最后两行（不用）
    for j=2:n-2  %第一列+最后两列（不用）
       if mod((i+j),2)==1 %白色块
           N_Blank = N_Blank+1; %记录黑色块噪声水平个数
           if Max_Blank < Noise_Blank(i,j)
               Max_Blank = Noise_Blank(i,j); %计算最大噪声水平
           end
       else
           Noise_Blank(i,j) = -1; %不用部分标记为-1
       end 
    end
end
S_Blank = zeros(1,M-1); %用来记录压缩划分区间
for v=0:M-2
    sum_Blank = 0; %记录噪声水平≤Sn的个数
    for Sn=0:Max_Blank
        for i=2:m-2     
            for j=2:n-2     
                if mod((i+j),2)==1 && Noise_Blank(i,j)==Sn   
                    sum_Blank = sum_Blank+1;  
                end     
            end     
        end 
        if sum_Blank/N_Blank >= (v+1)/M
            S_Blank(v+1) = Sn;
            break;
        else         
            continue;
        end
    end
end
for v=1:M %范围压缩
    for i=2:m-2           
        for j=2:n-2
            if v == 1
                if Noise_Blank(i,j)>=0 && Noise_Blank(i,j)<=S_Blank(v)
                    Noise_Blank(i,j) = v;
                end
            elseif v == M
                if Noise_Blank(i,j)>=S_Blank(v-1)+1
                    Noise_Blank(i,j) = v;
                end
            else
                if Noise_Blank(i,j)>=S_Blank(v-1)+1 && Noise_Blank(i,j)<=S_Blank(v)
                    Noise_Blank(i,j) = v;
                end
            end
        end
    end
end