function [exD,recover_I] = Extract(stego_I,s,num)
%stego_I表示载密图像，s,t是参数，num表示嵌入秘密数据的数量
%exD表示提取的数据，recover_I表示恢复图像
recover_I = stego_I; %构建存储恢复图像的容器
[m,n]=size(stego_I);%统计stego_I的行列数
exD = zeros();
num_exD = 0; %记录提取数据的个数
%% 计算每个分块嵌入数据的数量
num_ave = floor(num/9);%每个分块平均嵌入量
num_re = mod(num,9); %多余的数据
num_block = zeros(1,9);%记录每个分块的嵌入量
for i=1:9
    if i<=num_re
        num_block(i) = num_ave+1;
    else
        num_block(i) = num_ave;
    end
end
%% 遍历9层，分9层提取数据，从后往前
for hi=9:-1:1
    if num_exD >= num
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
                x1 = recover_I(i,j);
                x2 = recover_I(i,j+1); 
                x3 = recover_I(i,j+2); 
                x4 = recover_I(i+1,j); 
                x5 = recover_I(i+1,j+1); 
                x6 = recover_I(i+1,j+2); 
                x7 = recover_I(i+2,j);
                x8 = recover_I(i+2,j+1); 
                x9 = recover_I(i+2,j+2); 
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
    %% 求第hi层的块信息LM
    LM = zeros(1,k); %用来记录块信息
    LMc = zeros(); %用来记录溢出块信息
    len_k = ceil(log2(k)); %k的二进制位数，向上取整
    %--------求溢出块的个数l--------%
    num_l = 0; %记录I1中替换的LSB个数
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %防止越界  
                for i3=0:2  %每个分块的大小为3*3
                    for j3=0:2
                        if num_l>=len_k %前len_k表示溢出块个数
                            break;
                        end
                        value = recover_I(i+i3,j+j3);
                        num_l = num_l+1;
                        LMc(num_l) = mod(value,2);
                    end
                end
            end  
        end  
    end 
    str = num2str(LMc);%数组转换成字符串
    l =  bin2dec(str); %二进制字符串转换成整数
    %--------求溢出块的信息LMc--------%
    lc = (l+1)*len_k; %表示LMc的长度
    num_lc = 0;
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %防止越界  
                for i3=0:2  %每个分块的大小为3*3
                    for j3=0:2
                        if num_lc>=lc %前lc个像素的LSB表示溢出块信息
                            break;
                        end
                        value = recover_I(i+i3,j+j3);
                        num_lc = num_lc+1;
                        LMc(num_lc) = mod(value,2);
                    end
                end
            end  
        end  
    end
    %--------求所有分块的信息LM--------%
    for i=1:l %每len_k表示一个溢出块的信息
        str_i = LMc(i*len_k+1:(i+1)*len_k); %第i个溢出块的位置信息
        str = num2str(str_i); 
        ki =  bin2dec(str);
        LM(ki) = 1; %标记为溢出
    end
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
        elseif LM(ki)==0 && PV_x1(ki)-p_x1(ki)==1 && C_x1(ki)<s
            k2 = k2+1; 
        elseif LM(ki)==0 && PV_x1(ki)-q_x1(ki)==-1 && C_x1(ki)<s
            k2 = k2+1;
        elseif LM(ki)==0 && PV_x1(ki)-q_x1(ki)==-2 && C_x1(ki)<s
            k2 = k2+1;
        end
    end  %剩下的部分就属于I3 
    %% 在I2部分提取I1的LSB并恢复
    exk = 0; %记录提取块的位置
    S_LSB = zeros(); %记录I1中原始的LSB
    num_lsb = 0;
    for i=x:+3:m
        for j=y:+3:n
            if i+2<=m && j+2<=n  %防止越界
                exk = exk+1; 
                if exk>=k1+1 && exk<=k1+k2 %I2部分
                     if LM(exk)==0  %选择嵌入块或平移块，跳过溢出块
                        x1 = recover_I(i,j);
                        p = p_x1(exk);
                        q = q_x1(exk);
                        C = C_x1(exk);
                        if x1>p+1 && C<s  %平移块
                            x1 = x1 - 1;
                        elseif x1<q-2 && C<s  %平移块
                            x1 = x1 + 1;
                        else  %q-2<=x1<=p+1,C<s，嵌入块  
                            if x1==p && C<s  
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 0; 
                                x1 = x1 - 0;
                            elseif x1==p+1 && C<s
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 1;
                                x1 = x1 - 1;
                            elseif x1==q-2 && C<s 
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 1;
                                x1 = x1 + 1;
                            elseif x1==q-1 && C<s 
                                num_lsb = num_lsb+1; 
                                S_LSB(num_lsb) = 0;
                                x1 = x1 + 0;
                            end  
                        end
                        recover_I(i,j) = x1;  
                    end  
                end
            end
        end
    end
    %% 恢复I1中lc个像素的LSBs
    num_lsb = 0; %记录I1中替换的LSB个数
    for i=x:3:m 
        for j=y:3:n
            if i+2<=m && j+2<=n  %防止越界  
                for i3=0:2  %每个分块的大小为3*3
                    for j3=0:2
                        if num_lsb>=lc %最多替换lc个LSB
                            break;
                        end
                        value = recover_I(i+i3,j+j3);
                        num_lsb = num_lsb+1;
                        lsb = S_LSB(num_lsb);
                        value = bitset(value,1,lsb); %LSB替换
                        recover_I(i+i3,j+j3) = value;
                    end
                end
            end  
        end  
    end
    %% 重新计算I1部分的预测误差和复杂度
    k_I1 = 0;
    for i=x:+3:m
        for j=y:+3:n
            if k_I1>=k1
                break;
            end
            if i+2<=m && j+2<=n  %防止越界
                x1 = recover_I(i,j);
                x2 = recover_I(i,j+1); 
                x3 = recover_I(i,j+2); 
                x4 = recover_I(i+1,j); 
                x5 = recover_I(i+1,j+1); 
                x6 = recover_I(i+1,j+2); 
                x7 = recover_I(i+2,j);
                x8 = recover_I(i+2,j+1); 
                x9 = recover_I(i+2,j+2); 
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
    %% 在I1、I3部分提取数据
    exk = 0; %记录嵌入块的位置
    exD_hi = zeros(); %用来记录第k0层提取的数据
    num_hi = 0; %用来记录第k0层已提取数据的个数
    for i=x:+3:m
        for j=y:+3:n
            if num_hi >= num_block(hi)
                break;
            end
            if i+2<=m && j+2<=n  %防止越界
                exk = exk+1; 
                if exk<=k1 || exk>=k1+k2+1 %I1和I3部分
                    if LM(exk)==0  %选择嵌入块或平移块，跳过溢出块
                        x1 = recover_I(i,j);
                        p = p_x1(exk);
                        q = q_x1(exk);
                        C = C_x1(exk);
                        if x1>p+1 && C<s  %平移块
                            x1 = x1 - 1;
                        elseif x1<q-2 && C<s  %平移块
                            x1 = x1 + 1;
                        else  %q-2<=x1<=p+1,C<s，嵌入块  
                            if x1==p && C<s  
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 0;
                                x1 = x1 - 0;
                            elseif x1==p+1 && C<s
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 1; 
                                x1 = x1 - 1;
                            elseif x1==q-2 && C<s 
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 1; 
                                x1 = x1 + 1;
                            elseif x1==q-1 && C<s 
                                num_hi = num_hi+1;
                                exD_hi(num_hi) = 0;
                                x1 = x1 + 0;
                            end  
                        end
                        recover_I(i,j) = x1;  
                    end  
                end     
            end
        end
    end
    %% 记录提取的数据 
    ex2 = num-num_exD; %结束位置
    num_exD = num_exD+num_hi;
    ex1 = num-num_exD+1; %开始位置
    exD(ex1:ex2) = exD_hi;
end