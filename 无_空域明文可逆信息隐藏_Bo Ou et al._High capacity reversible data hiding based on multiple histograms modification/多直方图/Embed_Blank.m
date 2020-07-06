function [stego_I2,emD2,S_Blank,Opt_Blank,map,end_x,end_y] = Embed_Blank(stego_I1,D2)
%stego_I1表示在黑色部分嵌入信息后的载密图像，D2表示后面一半的秘密数据
%stego_I2表示在白色部分嵌入信息后的载密图像，emD2表示嵌入的数据
%S_Blank压缩噪声参数,Opt_Blank最优嵌入参数,map溢出信息,(end_x,end_y)结束位置
num_D2 = length(D2); %统计秘密数据个数
[m,n] = size(stego_I1); %统计stego_I1的行列数
stego_I2 = stego_I1;
%% 计算预测值、预测误差和噪声水平
[PV,PE,Noise] = Calculate(stego_I1);
%% 压缩噪声水平Noise
[~,~,Noise_Blank,S_Blank] = CompressNoise(Noise);
%% 统计直方图
M = 16;
sta_PE = cell(1,M); %统计没个噪声水平下的预测误差
for i = 2:m-2
    for j = 2:n-2
        if mod((i+j),2) == 1
            sta_PE{Noise_Blank(i,j)} = [sta_PE{Noise_Blank(i,j)},PE(i,j)];
        end
    end
end
Hist = cell(1,M); %存放M个直方图
for i = 1:M
    Hist{i} = tabulate(sta_PE{i}); %生成直方图
end
%% 求解最优参数
[Opt_Blank] = Optimal(Hist,num_D2);
% [Opt_Blank] = Optimal_Blank(Hist,num_D2);
%% 求解溢出信息
[map,~] = LocationMap(stego_I1,Noise_Blank,Opt_Blank);
%% 嵌入信息
num_emD2 = 0; %计数,记录嵌入数据个数
end_x = 0; %记录结束位置
end_y = 0;
[~,over] = size(map);
for i=2:m-2
    for j=2:n-2
        if num_emD2 >= num_D2
            break;
        end
        No = Noise_Blank(i,j);
        if No ~= -1
            v = PV(i,j); %预测值
            e = PE(i,j); %预测误差
            a = Opt_Blank(1,No); %最大嵌入对
            b = Opt_Blank(2,No); %外围嵌入点
            %% 判断是否为溢出点
            boole = 0;
            lo = (i-1)*512+j; %位置
            for l=1:over
                if lo == map(l);
                    boole = 1; %是溢出点
                end
            end
            
            if boole == 0
                %% 正常点嵌入平移
                if e>=0
                    if e == b %嵌入 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e + (a-1);
                        else  % D2(num_emD2) == 1                            
                            e = e + (a-1) + 1;                 
                        end   
                    elseif e>b  %平移
                        e = e + a;
                    elseif e>=a-1 && e<b %平移   
                        e = e + (a-1);
                    else  
                        for p=1:a-1  %嵌入
                            if e == p-1   
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e + (p-1);
                                else  % D2(num_emD2) == 1                           
                                    e = e + (p-1) + 1;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %嵌入 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e - (a-1);
                        else  % D2(num_emD2) == 1                            
                            e = e - (a-1) - 1;                 
                        end   
                    elseif e<-1-b  %平移
                        e = e - a;
                    elseif e<=-a && e>-1-b %平移   
                        e = e - (a-1);
                    else  
                        for p=1:a-1  %嵌入
                            if e == -p  
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e - (p-1);
                                else  % D2(num_emD2) == 1                           
                                    e = e - (p-1) - 1;
                                end 
                                break;
                            end
                        end  
                    end
                end
            else  %boole == 1
                %% 溢出点嵌入平移
                if e>=0
                    if e == b %嵌入 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e + (a-1) - a;
                        else  % D2(num_emD2) == 1                            
                            e = e + (a-1) + 1 - a;                 
                        end   
                    elseif e>b  %平移
                        e = e + a - a;
                    elseif e>=a-1 && e<b %平移   
                        e = e + (a-1) - a;
                    else  
                        for p=1:a-1  %嵌入
                            if e == p-1   
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e + (p-1) - a;
                                else  % D2(num_emD2) == 1                           
                                    e = e + (p-1) + 1 - a;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %嵌入 
                        num_emD2 = num_emD2+1;        
                        if D2(num_emD2) == 0  
                            e = e - (a-1) + a;
                        else  % D2(num_emD2) == 1                            
                            e = e - (a-1) - 1 + a;                 
                        end   
                    elseif e<-1-b  %平移
                        e = e - a + a;
                    elseif e<=-a && e>-1-b %平移   
                        e = e - (a-1) + a;
                    else  
                        for p=1:a-1  %嵌入
                            if e == -p  
                                num_emD2 = num_emD2+1;
                                if D2(num_emD2) == 0
                                    e = e - (p-1) + a;
                                else  % D2(num_emD2) == 1                           
                                    e = e - (p-1) - 1 + a;
                                end 
                                break;
                            end
                        end  
                    end
                end
            end
            stego_I2(i,j) = v + e;
            end_x = i;
            end_y = j;
        end
    end
end
%% 记录嵌入数据
emD2 = D2(1:num_emD2);
end