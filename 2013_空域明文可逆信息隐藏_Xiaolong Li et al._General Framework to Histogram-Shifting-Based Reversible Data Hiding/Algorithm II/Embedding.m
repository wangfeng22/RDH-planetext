function [emD,num_emD,stego_I] = Embedding(D,origin_I,s)
%origin_I表示原始图像，D表示秘密数据，s是参数
%stego_I表示载密图像，emD表示已嵌入的数据，num_emD表示嵌入数据的个数
stego_I = origin_I; %构建存储载密图像的容器
[m,n]=size(origin_I);%统计origin_I的行列数
num_emD = 0; %记录嵌入数据的个数
num_D = length(D);
%% 计算每个分块嵌入数据的数量
num_ave = floor(num_D/9);%每个分块平均嵌入量
num_re = mod(num_D,9); %多余的数据
num_block = zeros(1,9);%记录每个分块的嵌入量
for i=1:9
    if i<=num_re
        num_block(i) = num_ave+1;
    else
        num_block(i) = num_ave;
    end
end
%% 遍历9层，可以分9层嵌入数据
for hi=1:9 
    if num_emD >= num_D
        break;
    end
    %------第一个分块开始位置------%
    x = ceil(hi/3); %行,向上取整     
    y = hi-(x-1)*3; %列
    %% 求预测误差和复杂度
    PV_x1 = zeros();%记录x1的值
    p_x1 = zeros();%记录参数p
    q_x1 = zeros();%记录参数q
    C_x1 = zeros(); %记录复杂度
    k = 0; %分块个数
    for i=x:+3:m
        for j=y:+3:n
            if i+2<=m && j+2<=n  %防止越界
                x1 = stego_I(i,j);
                x2 = stego_I(i,j+1); 
                x3 = stego_I(i,j+2); 
                x4 = stego_I(i+1,j); 
                x5 = stego_I(i+1,j+1); 
                x6 = stego_I(i+1,j+2); 
                x7 = stego_I(i+2,j);
                x8 = stego_I(i+2,j+1); 
                x9 = stego_I(i+2,j+2); 
                p = max(x2,x4);
                q = min(x2,x4);
                C_max = max(max(max(max(max(max(max(x2,x3),x4),x5),x6),x7),x8),x9); 
                C_min = min(min(min(min(min(min(min(x2,x3),x4),x5),x6),x7),x8),x9);
                C = C_max - C_min;
                k = k+1;
                PV_x1(k) = x1;
                p_x1(k) = p;
                q_x1(k) = q;
                C_x1(k) = C;
            end
        end
    end
    %% 求第hi层的块信息
    [lc,LM,LMc] = Overflow(x,y,stego_I,s,C_x1);      
    %% 将所有块分成三部分I1、I2、I3
    k1 = ceil(lc/9); %I1部分有k1块，通过LSB替换嵌入LMc
    k2 =0; %I2部分有k2块，用来嵌入I1的LSB
    for ki=k1+1:k
        if k2 == lc %至少包含lc个可嵌入块
            k2 = ki-k1-1;
            break;
        end
        if LM(ki)==0 && PV_x1(ki)-p_x1(ki)==0 && C_x1(ki)<s
            k2 = k2+1;
        elseif LM(ki)==0 && PV_x1(ki)-q_x1(ki)==-1 && C_x1(ki)<s
            k2 = k2+1;
        end
    end  %剩下的部分就属于I3
    %% 在I1、I3部分嵌入数据
    emk = 0; %记录嵌入块的位置
    num_hi = 0; %用来记录第k0层已侵入数据的个数
    for i=x:+3:m
        for j=y:+3:n
            if num_hi >= num_block(hi)
                break;
            end
            if i+2<=m && j+2<=n  %防止越界
                emk = emk+1; 
                if emk<=k1 || emk>=k1+k2+1 %I1和I3部分
                    if LM(emk)==0  %选择嵌入块或平移块，跳过溢出块
                        x1 = stego_I(i,j);
                        p = p_x1(emk);
                        q = q_x1(emk);
                        C = C_x1(emk);
                        if x1>p && C<s  %平移块
                            x1 = x1 + 1;
                        elseif x1<q-1 && C<s  %平移块
                            x1 = x1 - 1;
                        else  %x1-p=0||x1-q=-1,C<s，嵌入块
                            if x1-p==0 && C<s
                                num_hi = num_hi+1;
                                num_emD = num_emD+1;
                                x1 = x1 + D(num_emD);
                            elseif x1-q==-1 && C<s
                                num_hi = num_hi+1;
                                num_emD = num_emD+1;
                                x1 = x1 - D(num_emD);
                            end
                        end
                        stego_I(i,j) = x1;  
                    end  
                end     
            end
        end
    end
    %% 在I1中嵌入LMc，提取I1中lc个像素的LSBs
    num_lsb = 0; %记录I1中替换的LSB个数
    S_LSB = zeros(); %记录I1中原始的LSB
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %防止越界  
                for i3=0:2  %每个分块的大小为3*3
                    for j3=0:2
                        if num_lsb>=lc %最多替换lc个LSB
                            break;
                        end
                        value = stego_I(i+i3,j+j3);
                        num_lsb = num_lsb+1;
                        S_LSB(num_lsb) = mod(value,2);
                        value = bitset(value,1,LMc(num_lsb)); %LSB替换
                        stego_I(i+i3,j+j3) = value;
                    end
                end
            end  
        end  
    end 
    %% 在I2中嵌入I1前lc个像素的LSBs序列S_LSB
    emk = 0; %记录嵌入块的位置
    num_lsb = 0;
    for i=x:+3:m
        for j=y:+3:n
            if i+2<=m && j+2<=n  %防止越界
                emk = emk+1; 
                if emk>=k1+1 && emk<=k1+k2 %I2部分
                     if LM(emk)==0  %选择嵌入块或平移块，跳过溢出块 
                         x1 = stego_I(i,j); 
                         p = p_x1(emk);
                         q = q_x1(emk);
                         C = C_x1(emk);
                         if x1>p && C<s  %平移块
                            x1 = x1 + 1;
                         elseif x1<q-1 && C<s  %平移块
                             x1 = x1 - 1;
                         else %x1-p=0||x1-q=-1,C<s，嵌入块 
                             if x1-p==0 && C<s
                                 num_lsb = num_lsb+1;
                                 x1 = x1 + S_LSB(num_lsb);
                             elseif x1-q==-1 && C<s
                                 num_lsb = num_lsb+1;
                                 x1 = x1 - S_LSB(num_lsb);
                             end 
                         end
                         stego_I(i,j) = x1;
                    end  
                end
            end
        end
    end
end
%% 记录嵌入的数据
emD = D(1:num_emD);
end