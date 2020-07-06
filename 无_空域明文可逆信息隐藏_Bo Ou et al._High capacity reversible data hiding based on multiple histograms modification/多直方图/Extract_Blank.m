function [recover_I1,exD1] = Extract_Blank(stego_I,S_Blank,Opt_Blank,map,end_x,end_y)
%stego_I表示在白色部分嵌入信息后的载密图像
%S_Blank压缩噪声参数,Opt_Blank最优嵌入参数,map溢出信息,(end_x,end_y)结束位置
%recover_I1表示恢复白色部分嵌入信息后的恢复图像，exD1表示提取的数据
[~,n] = size(stego_I);
exD1 = zeros();
num_exD1 = 0; %计数
I = stego_I;
for i = end_x:-1:2
    if i == end_x
        %% 嵌入结束行
        for j =end_y:-1:2
            if mod((i+j),2)==1
            w1 =  I(i-1,j); %上
            w2 =  I(i,j-1); %左
            w3 =  I(i+1,j); %下
            w4 =  I(i,j+1); %右
            w5 =  I(i+1,j-1);
            w6 =  I(i+1,j+1);
            w7 =  I(i+2,j);       
            w8 =  I(i,j+2);
            w9 =  I(i+2,j-1);
            w10 =  I(i-1,j+2);
            w11 =  I(i+2,j+1);
            w12 =  I(i+1,j+2);
            w13 =  I(i+2,j+2);
            PV = floor((w1+w2+w3+w4)/4); %(i,j)处的预测值，上下左右取平均值
            PE = I(i,j) - PV; %预测误差
            Noise = abs(w2-w5)+abs(w5-w9)+abs(w3-w7)+abs(w4-w6)+abs(w6-w11)+abs(w10-w8)+abs(w8-w12)+abs(w12-w13)...
                +abs(w4-w8)+abs(w5-w3)+abs(w3-w6)+abs(w6-w12)+abs(w9-w7)+abs(w7-w11)+abs(w11-w13);  %计算噪声水平
            %% 计算属于哪个直方图
            if Noise <= S_Blank(1)
                h_n = 1;
            elseif Noise > S_Blank(15)
                h_n = 16;
            else 
                for s=2:15
                    if Noise>S_Blank(s-1) && Noise<=S_Blank(s)
                        h_n = s;
                        break;
                    end
                end
            end 
             %% 判断是否为溢出点
            flag = 0;
            [~,over] = size(map);
            lo = (i-1)*512+j; %位置
            for l=1:over
                if lo == map(l);
                    flag = 1; %是溢出点
                    break;
                end
            end
            %% 提取信息
            a = Opt_Blank(1,h_n); %最大嵌入对
            b = Opt_Blank(2,h_n); %外围嵌入点
            
            if flag == 0
                %% 正常点提取信息
                 if PE>=0
                    if PE == b+(a-1) %提取0 
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %提取1
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %平移
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %平移   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %提取0
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %提取1
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0         
                     if PE == -1-b-(a-1) %提取0           
                         num_exD1 = num_exD1+1;      
                         exD1(num_exD1) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %提取1  
                         num_exD1 = num_exD1+1;
                         exD1(num_exD1) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %平移      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %平移   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %提取0
                                 num_exD1 = num_exD1+1;
                                 exD1(num_exD1) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %提取1
                                 num_exD1 = num_exD1+1; 
                                 exD1(num_exD1) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end   
                 end
            else % flag == 0
                %% 溢出点提取信息
                if PE>=0
                    PE = PE + a;
                    if PE == b+(a-1) %提取0 
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %提取1
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %平移
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %平移   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %提取0
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %提取1
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0
                     PE = PE - a;
                     if PE == -1-b-(a-1) %提取0           
                         num_exD1 = num_exD1+1;      
                         exD1(num_exD1) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %提取1  
                         num_exD1 = num_exD1+1;
                         exD1(num_exD1) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %平移      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %平移   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %提取0
                                 num_exD1 = num_exD1+1;
                                 exD1(num_exD1) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %提取1
                                 num_exD1 = num_exD1+1; 
                                 exD1(num_exD1) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end 
                end         
            end
            I(i,j) = PV + PE;
            end    
        end
    else
        %% 嵌入结束行之前每行提取信息
        for j = n-2:-1:2
            if mod((i+j),2)==1
            w1 =  I(i-1,j); %上
            w2 =  I(i,j-1); %左
            w3 =  I(i+1,j); %下
            w4 =  I(i,j+1); %右
            w5 =  I(i+1,j-1);
            w6 =  I(i+1,j+1);
            w7 =  I(i+2,j);       
            w8 =  I(i,j+2);
            w9 =  I(i+2,j-1);
            w10 =  I(i-1,j+2);
            w11 =  I(i+2,j+1);
            w12 =  I(i+1,j+2);
            w13 =  I(i+2,j+2);
            PV = floor((w1+w2+w3+w4)/4); %(i,j)处的预测值，上下左右取平均值
            PE = I(i,j) - PV; %预测误差
            Noise = abs(w2-w5)+abs(w5-w9)+abs(w3-w7)+abs(w4-w6)+abs(w6-w11)+abs(w10-w8)+abs(w8-w12)+abs(w12-w13)...
                +abs(w4-w8)+abs(w5-w3)+abs(w3-w6)+abs(w6-w12)+abs(w9-w7)+abs(w7-w11)+abs(w11-w13);  %计算噪声水平
            %% 计算属于哪个直方图
            if Noise <= S_Blank(1)
                h_n = 1;
            elseif Noise > S_Blank(15)
                h_n = 16;
            else 
                for s=2:15
                    if Noise>S_Blank(s-1) && Noise<=S_Blank(s)
                        h_n = s;
                        break;
                    end
                end
            end 
             %% 判断是否为溢出点
            flag = 0;
            [~,over] = size(map);
            lo = (i-1)*512+j; %位置
            for l=1:over
                if lo == map(l);
                    flag = 1; %是溢出点
                    break;
                end
            end
            %% 提取信息
            a = Opt_Blank(1,h_n); %最大嵌入对
            b = Opt_Blank(2,h_n); %外围嵌入点
            if flag == 0
                %% 正常点提取信息
                 if PE>=0
                    if PE == b+(a-1) %提取0 
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %提取1
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %平移
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %平移   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %提取0
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %提取1
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0         
                     if PE == -1-b-(a-1) %提取0           
                         num_exD1 = num_exD1+1;      
                         exD1(num_exD1) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %提取1  
                         num_exD1 = num_exD1+1;
                         exD1(num_exD1) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %平移      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %平移   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %提取0
                                 num_exD1 = num_exD1+1;
                                 exD1(num_exD1) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %提取1
                                 num_exD1 = num_exD1+1; 
                                 exD1(num_exD1) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end   
                 end
            else % flag == 0
                %% 溢出点提取信息
                if PE>=0
                    PE = PE + a;
                    if PE == b+(a-1) %提取0 
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 0;
                        PE = PE - (a-1);
                    elseif PE == b+(a-1)+1 %提取1
                        num_exD1 = num_exD1+1;
                        exD1(num_exD1) = 1;
                        PE = PE - (a-1) - 1;
                    elseif PE > b+a  %平移
                        PE = PE - a;
                    elseif PE>=2*(a-1) && PE<b+(a-1) %平移   
                        PE = PE - (a-1);
                    else
                        for p=0:a-2
                            if PE == 2*p  %提取0
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 0;
                                PE = PE - p;
                                break;      
                            elseif PE == 2*p+1 %提取1
                                num_exD1 = num_exD1+1;
                                exD1(num_exD1) = 1;
                                PE = PE - p -1;
                                break;
                            end
                        end  
                    end
                 else %PE<0
                     PE = PE - a;
                     if PE == -1-b-(a-1) %提取0           
                         num_exD1 = num_exD1+1;      
                         exD1(num_exD1) = 0;
                         PE = PE + (a-1);         
                     elseif PE == -2-b-(a-1) %提取1  
                         num_exD1 = num_exD1+1;
                         exD1(num_exD1) = 1;
                         PE = PE + (a-1) + 1;
                     elseif PE <= -2-b-a  %平移      
                         PE = PE + a;    
                     elseif PE<-2*(a-1) && PE>-1-b-(a-1) %平移   
                         PE = PE + (a-1);
                     else     
                         for p=1:a-1 
                             if PE == -2*p+1  %提取0
                                 num_exD1 = num_exD1+1;
                                 exD1(num_exD1) = 0;  
                                 PE = PE + (p-1);
                                 break;
                             elseif PE == -2*p  %提取1
                                 num_exD1 = num_exD1+1; 
                                 exD1(num_exD1) = 1;
                                 PE = PE + (p-1) + 1;
                                 break;
                             end  
                         end  
                     end 
                end         
            end
            I(i,j) = PV + PE;
            end
        end
    end    
end
%% 记录提取信息
recover_I1 = I;
exD = exD1;
for i=1:num_exD1
    exD1(i) = exD(num_exD1-i+1); %逆序
end