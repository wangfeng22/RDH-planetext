function [stego_I,emD,sign] = embed(origin_I,D)
%origin_I表示原始载体图像，D表示嵌入数据
num = length(D);
sign = -1; %标记
t = 0; %计数
[m,n] = size(origin_I);
stego_I = origin_I;
%% 先在(1,1)位置开始的菱形区域嵌入信息
%计算origin_I的预测值和预测误差
[diaPV_I,diaPE_I] = diamond(origin_I);
for i=1:m
    if mod(i,4)==3 || mod(i,4)==0
        continue; %跳过已嵌入信息的行
    elseif i+2 > m
        break; %无对应向量，结束；防止行越界
    end
    for j=1:n
        if t == num  %嵌入完毕   
            break; 
        end
        if mod(i+j,2) ~= 0 
            continue; %跳过该点
        else %选取(1,1)、(1,3)、（2,2）等点
            x = diaPE_I(i,j); %构建一对预测误差向量（x,y）
            y = diaPE_I(i+2,j);
            %所有向量分四块，第1块
            if x >= 0 && y >= 0 
                if  x==1 && y==1 %嵌入0时(1,1)→(1,1),嵌入1时(1,1)→(2,2)
                    t = t + 1;
                    x = x + D(t); 
                    y = y + D(t); 
                elseif x==0 && y==0
                    t = t + 1;
                    if t+1 <= num %嵌入数据还剩下2位以上
                        if D(t)==1 && D(t+1) ==0
                            y = y + 1; %嵌入10时(0,0)→(0,1) 
                            t = t + 1;
                        else %嵌入0时(0,0)→(0,0),嵌入1时(0,0)→(1,0)
                            x = x + D(t);
                        end
                    else %只剩一位待嵌入数据
                        x = x + D(t);
                    end
                elseif x>=1 && y==0 %嵌入0时(x,0)→(x+1,0),嵌入1时(x,0)→(x+1,1)
                    t = t + 1;
                    x = x + 1;
                    y = y + D(t);
                elseif x==0 && y>=1 %嵌入0时(0,y)→(0,y+1),嵌入1时(0,y)→(1,y+1)
                    t = t + 1;
                    x = x + D(t);
                    y = y + 1;                              
                else  %剩下的点全部右上方向平移一位
                    x = x + 1;
                    y = y + 1;
                end
            %所有向量分四块，第2块
            elseif x <= -1 && y >= 0
                if  x==-2 && y==1 %嵌入0时(-2,1)→(-2,1),嵌入1时(-2,1)→(-3,2)
                    t = t + 1;
                    x = x - D(t); 
                    y = y + D(t); 
                elseif x==-1 && y==0
                    t = t + 1;
                    if t+1 <= num %嵌入数据还剩下2位以上
                        if D(t)==1 && D(t+1) ==0
                            y = y + 1; %嵌入10时(-1,0)→(-1,1) 
                            t = t + 1;
                        else %嵌入0时(-1,0)→(-1,0),嵌入1时(-1,0)→(-2,0)
                            x = x - D(t);
                        end
                    else %只剩一位待嵌入数据
                        x = x - D(t);
                    end
                elseif x<=-2 && y==0 %嵌入0时(x,0)→(x-1,0),嵌入1时(x,0)→(x-1,1)
                    t = t + 1;
                    x = x - 1;
                    y = y + D(t);
                elseif x==-1 && y>=1 %嵌入0时(-1,y)→(-1,y+1),嵌入1时(-1,y)→(-2,y+1)
                    t = t + 1;
                    x = x - D(t);
                    y = y + 1;
                else  %剩下的点全部左上方向平移一位
                    x = x - 1;
                    y = y + 1;
                 end
            %所有向量分四块，第3块
            elseif x <= -1 && y <= -1
                if  x==-2 && y==-2 %嵌入0时(-2,-2)→(-2,-2),嵌入1时(-2,-2)→(-3,-3)
                    t = t + 1;
                    x = x - D(t); 
                    y = y - D(t); 
                elseif x==-1 && y==-1
                    t = t + 1;
                    if t+1 <= num %嵌入数据还剩下2位以上
                        if D(t)==1 && D(t+1) ==0
                            y = y - 1; %嵌入10时(-1,-1)→(-1,-2) 
                            t = t + 1;
                        else %嵌入0时(-1,-1)→(-1,-1),嵌入1时(-1,-1)→(-2,-1)
                            x = x - D(t);
                        end
                    else %只剩一位待嵌入数据
                        x = x - D(t);
                    end
                elseif x<=-2 && y==-1 %嵌入0时(x,-1)→(x-1,-1),嵌入1时(x,-1)→(x-1,-2)
                    t = t + 1;
                    x = x - 1;
                    y = y - D(t);
                elseif x==-1 && y<=-2 %嵌入0时(-1,y)→(-1,y-1),嵌入1时(-1,y)→(-2,y-1)
                    t = t + 1;
                    x = x - D(t);
                    y = y - 1;
                else  %剩下的点全部左下方向平移一位
                    x = x - 1;
                    y = y - 1;
                 end
            %所有向量分四块，第4块
            elseif x >= 0 && y <= -1
                if  x==1 && y==-2 %嵌入0时(1,-2)→(1,-2),嵌入1时(1,-2)→(2,-3)
                    t = t + 1;
                    x = x + D(t); 
                    y = y - D(t); 
                elseif x==0 && y==-1
                    t = t + 1;
                    if t+1 <= num %嵌入数据还剩下2位以上
                        if D(t)==1 && D(t+1) ==0
                            y = y - 1; %嵌入10时(0,-1)→(0,-2)  
                            t = t + 1;
                        else %嵌入0时(0,-1)→(0,-1),嵌入1时(0,-1)→(1,-1)
                            x = x + D(t);
                        end
                    else %只剩一位待嵌入数据
                        x = x + D(t);
                    end
                elseif x>=1 && y==-1 %嵌入0时(x,-1)→(x+1,-1),嵌入1时(x,-1)→(x+1,-2)
                    t = t + 1;
                    x = x + 1;
                    y = y - D(t);
                elseif x==0 && y<=-2 %嵌入0时(0,y)→(0,y-1),嵌入1时(0,y)→(1,y-1)
                    t = t + 1;
                    x = x + D(t);
                    y = y - 1;
                else  %剩下的点全部右下方向平移一位
                    x = x + 1;
                    y = y - 1;
                end
            end 
            stego_I(i,j) = diaPV_I(i,j) + x; 
            stego_I(i+2,j) = diaPV_I(i+2,j) + y;
        end
    end
end
%% 若数据没有嵌完，再在(1,2)位置开始的菱形区域嵌入信息
if t < num
    sign = t;
    %计算已嵌入部分数据的stego_I的预测值和预测误差
    [diaPV_I1,diaPE_I1] = diamond(stego_I); 
    for i=1:m
        if mod(i,4)==3 || mod(i,4)==0
            continue; %跳过已嵌入信息的行
        elseif i+2 > m
            break; %无对应向量，结束；防止行越界
        end
        for j=1:n
            if t == num  %嵌入完毕  
                break; 
            end
            if mod(i+j,2) ~= 1
                continue; %跳过该点
            else %选取(1,2)、(1,4)、（2,1）等点
                x = diaPE_I1(i,j); %构建一对预测误差向量（x,y）
                y = diaPE_I1(i+2,j);
                %所有向量分四块，第1块
                if x >= 0 && y >= 0                   
                    if  x==1 && y==1 %嵌入0时(1,1)→(1,1),嵌入1时(1,1)→(2,2)
                        t = t + 1;   
                        x = x + D(t); 
                        y = y + D(t); 
                    elseif x==0 && y==0     
                        t = t + 1;
                        if t+1 <= num %嵌入数据还剩下2位以上  
                            if D(t)==1 && D(t+1) ==0 
                                y = y + 1; %嵌入10时(0,0)→(0,1) 
                                t = t + 1;
                            else %嵌入0时(0,0)→(0,0),嵌入1时(0,0)→(1,0)       
                                x = x + D(t);
                            end                         
                        else %只剩一位待嵌入数据                   
                            x = x + D(t);                   
                        end      
                    elseif x>=1 && y==0 %嵌入0时(x,0)→(x+1,0),嵌入1时(x,0)→(x+1,1)  
                        t = t + 1;
                        x = x + 1;  
                        y = y + D(t);
                    elseif x==0 && y>=1 %嵌入0时(0,y)→(0,y+1),嵌入1时(0,y)→(1,y+1)
                        t = t + 1;  
                        x = x + D(t);
                        y = y + 1;
                    else  %剩下的点全部右上方向平移一位    
                        x = x + 1;
                        y = y + 1;
                    end
                %所有向量分四块，第2块
                elseif x <= -1 && y >= 0
                    if  x==-2 && y==1 %嵌入0时(-2,1)→(-2,1),嵌入1时(-2,1)→(-3,2)
                        t = t + 1;
                        x = x - D(t); 
                        y = y + D(t); 
                    elseif x==-1 && y==0 
                        t = t + 1;
                        if t+1 <= num %嵌入数据还剩下2位以上
                            if D(t)==1 && D(t+1) ==0
                                y = y + 1; %嵌入10时(-1,0)→(-1,1) 
                                t = t + 1;
                            else %嵌入0时(-1,0)→(-1,0),嵌入1时(-1,0)→(-2,0)
                                x = x - D(t);
                            end 
                        else %只剩一位待嵌入数据
                            x = x - D(t);
                        end 
                    elseif x<=-2 && y==0 %嵌入0时(x,0)→(x-1,0),嵌入1时(x,0)→(x-1,1)
                        t = t + 1;     
                        x = x - 1;
                        y = y + D(t);
                    elseif x==-1 && y>=1 %嵌入0时(-1,y)→(-1,y+1),嵌入1时(-1,y)→(-2,y+1)
                        t = t + 1;  
                        x = x - D(t);
                        y = y + 1;
                    else  %剩下的点全部左上方向平移一位
                        x = x - 1;
                        y = y + 1;
                    end 
                %所有向量分四块，第3块
                elseif x <= -1 && y <= -1            
                    if  x==-2 && y==-2 %嵌入0时(-2,-2)→(-2,-2),嵌入1时(-2,-2)→(-3,-3)  
                        t = t + 1;      
                        x = x - D(t); 
                        y = y - D(t); 
                    elseif x==-1 && y==-1
                        t = t + 1;       
                        if t+1 <= num %嵌入数据还剩下2位以上                     
                            if D(t)==1 && D(t+1) ==0                         
                                y = y - 1; %嵌入10时(-1,-1)→(-1,-2) 
                                t = t + 1;                       
                            else %嵌入0时(-1,-1)→(-1,-1),嵌入1时(-1,-1)→(-2,-1)                          
                                x = x - D(t);                        
                            end                            
                        else %只剩一位待嵌入数据                       
                            x = x - D(t);                
                        end                       
                    elseif x<=-2 && y==-1 %嵌入0时(x,-1)→(x-1,-1),嵌入1时(x,-1)→(x-1,-2)                   
                        t = t + 1;                  
                        x = x - 1;                  
                        y = y - D(t);             
                    elseif x==-1 && y<=-2 %嵌入0时(-1,y)→(-1,y-1),嵌入1时(-1,y)→(-2,y-1)                 
                        t = t + 1;                   
                        x = x - D(t);
                        y = y - 1;
                    else  %剩下的点全部左下方向平移一位           
                        x = x - 1;
                        y = y - 1;
                    end   
                %所有向量分四块，第4块
                elseif x >= 0 && y <= -1
                    if  x==1 && y==-2 %嵌入0时(1,-2)→(1,-2),嵌入1时(1,-2)→(2,-3)            
                        t = t + 1;           
                        x = x + D(t); 
                        y = y - D(t); 
                    elseif x==0 && y==-1
                        t = t + 1;
                        if t+1 <= num %嵌入数据还剩下2位以上                      
                            if D(t)==1 && D(t+1) ==0
                                y = y - 1; %嵌入10时(0,-1)→(0,-2) 
                                t = t + 1;                       
                            else %嵌入0时(0,-1)→(0,-1),嵌入1时(0,-1)→(1,-1)                           
                                x = x + D(t);
                            end 
                        else %只剩一位待嵌入数据
                            x = x + D(t);
                        end  
                    elseif x>=1 && y==-1 %嵌入0时(x,-1)→(x+1,-1),嵌入1时(x,-1)→(x+1,-2)  
                        t = t + 1;
                        x = x + 1;
                        y = y - D(t);
                    elseif x==0 && y<=-2 %嵌入0时(0,y)→(0,y-1),嵌入1时(0,y)→(1,y-1)   
                        t = t + 1;
                        x = x + D(t);
                        y = y - 1;
                    else  %剩下的点全部右下方向平移一位 
                        x = x + 1;
                        y = y - 1;
                    end       
                end 
                stego_I(i,j) = diaPV_I1(i,j) + x; 
                stego_I(i+2,j) = diaPV_I1(i+2,j) + y;
            end   
        end 
    end
end
emD = D(1:t); %已嵌入的数据
end