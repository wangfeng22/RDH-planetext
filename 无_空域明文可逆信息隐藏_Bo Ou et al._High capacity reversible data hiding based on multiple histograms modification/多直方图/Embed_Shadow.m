function [stego_I1,emD1,S_Shadow,Opt_Shadow,map,end_x,end_y] = Embed_Shadow(origin_I,D1)
%origin_I表示原始图像，D1表示前面一半的秘密数据
%stego_I1表示在黑色部分嵌入信息后的载密图像，emD1表示嵌入的数据
%S_Shadow压缩噪声参数,Opt_Shadow最优嵌入参数,map溢出信息,(end_x,end_y)结束位置
num_D1 = length(D1); %统计秘密数据个数
[m,n] = size(origin_I); %统计origin_I的行列数
stego_I1 = origin_I;
%% 计算预测值、预测误差和噪声水平
[PV,PE,Noise] = Calculate(origin_I);
%% 压缩噪声水平Noise
[Noise_Shadow,S_Shadow,~,~] = CompressNoise(Noise);
%% 统计直方图
M = 16;
sta_PE = cell(1,M); %统计没个噪声水平下的预测误差
for i = 2:m-2
    for j = 2:n-2
        if mod((i+j),2) == 0
            sta_PE{Noise_Shadow(i,j)} = [sta_PE{Noise_Shadow(i,j)},PE(i,j)];
        end
    end
end
Hist = cell(1,M); %存放M个直方图
for i = 1:M
    Hist{i} = tabulate(sta_PE{i}); %生成直方图
end
%% 求解最优参数
[Opt_Shadow] = Optimal(Hist,num_D1);
% [Opt_Shadow] = Optimal_Shadow(Hist,num_D1) ;
%% 求解溢出信息
[map,~] = LocationMap(origin_I,Noise_Shadow,Opt_Shadow);
%% 嵌入信息
num_emD1 = 0; %计数,记录嵌入数据个数
end_x = 0; %记录结束位置
end_y = 0;
[~,over] = size(map);
for i=2:m-2
    for j=2:n-2
        if num_emD1 >= num_D1
            break;
        end
        No = Noise_Shadow(i,j);
        if No ~= -1
            v = PV(i,j); %预测值
            e = PE(i,j); %预测误差
            a = Opt_Shadow(1,No); %最大嵌入对
            b = Opt_Shadow(2,No); %外围嵌入点
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
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e + (a-1);
                        else  % D1(num_emD1) == 1                            
                            e = e + (a-1) + 1;                 
                        end   
                    elseif e>b  %平移
                        e = e + a;
                    elseif e>=a-1 && e<b %平移   
                        e = e + (a-1);
                    else  
                        for p=1:a-1  %嵌入
                            if e == p-1   
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e + (p-1);
                                else  % D1(num_emD1) == 1                           
                                    e = e + (p-1) + 1;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %嵌入 
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e - (a-1);
                        else  % D1(num_emD1) == 1                            
                            e = e - (a-1) - 1;                 
                        end   
                    elseif e<-1-b  %平移
                        e = e - a;
                    elseif e<=-a && e>-1-b %平移   
                        e = e - (a-1);
                    else  
                        for p=1:a-1  %嵌入
                            if e == -p  
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e - (p-1);
                                else  % D1(num_emD1) == 1                           
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
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e + (a-1) - a;
                        else  % D1(num_emD1) == 1                            
                            e = e + (a-1) + 1 - a;                 
                        end   
                    elseif e>b  %平移
                        e = e + a - a;
                    elseif e>=a-1 && e<b %平移   
                        e = e + (a-1) - a;
                    else  
                        for p=1:a-1  %嵌入
                            if e == p-1   
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e + (p-1) - a;
                                else  % D1(num_emD1) == 1                           
                                    e = e + (p-1) + 1 - a;
                                end 
                                break;
                            end
                        end  
                    end
                else  %e<0
                    if e == -1-b %嵌入 
                        num_emD1 = num_emD1+1;        
                        if D1(num_emD1) == 0  
                            e = e - (a-1) + a;
                        else  % D1(num_emD1) == 1                            
                            e = e - (a-1) - 1 + a;                 
                        end   
                    elseif e<-1-b  %平移
                        e = e - a + a;
                    elseif e<=-a && e>-1-b %平移   
                        e = e - (a-1) + a;
                    else  
                        for p=1:a-1  %嵌入
                            if e == -p  
                                num_emD1 = num_emD1+1;
                                if D1(num_emD1) == 0
                                    e = e - (p-1) + a;
                                else  % D1(num_emD1) == 1                           
                                    e = e - (p-1) - 1 + a;
                                end 
                                break;
                            end
                        end  
                    end
                end
            end
            stego_I1(i,j) = v + e;
            end_x = i;
            end_y = j;
        end
    end
end
%% 记录嵌入数据
emD1 = D1(1:num_emD1);
end