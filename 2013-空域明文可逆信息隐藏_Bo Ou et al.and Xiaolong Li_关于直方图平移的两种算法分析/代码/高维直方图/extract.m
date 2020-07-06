function [recover_I,exD] = extract(stego_I,num,sign)
%stego_I表示载密图像，num表示嵌入数据量，sign是标记
exD = zeros(); 
[m,n] = size(stego_I);
recover_I = stego_I;
%% 先判断(1,2)位置开始的菱形区域是否嵌入了信息
if sign ~= -1  %sign不等于-1表示嵌入了信息
    [diaPV_I,diaPE_I] = diamond(stego_I);
    t = sign;  %计数
    for i=1:m
        if mod(i,4)==3 || mod(i,4)==0
            continue; %跳过已提取数据的行
        elseif i+2 > m
            break; %无对应向量，结束；防止行越界
        end
        for j=1:n
            if t == num  %提取完毕   
                break; 
            end
            if mod(i+j,2) == 0
                continue; %跳过该点
            else %选取(1,2)、(1,4)、（2,1）等点 
                x = diaPE_I(i,j); %构建一对预测误差向量（x,y）
                y = diaPE_I(i+2,j);
                %所有向量分四块，第1块              
                if x >= 0 && y >= 0 
                    if (x==1 && y==1) || (x==0 && y==0) %(1,1)和(0,0)处提取数据0
                        t = t + 1;
                        exD(t) = 0;
                    elseif x==2 && y==2 %(2,2)处提取数据1→(1,1)
                        t = t + 1;
                        exD(t) = 1;
                        x = 1; 
                        y = 1; 
                    elseif x==1 && y==0 %(1,0)处提取数据1→(0,0)
                        t = t + 1;  
                        exD(t) = 1;  
                        x = 0; 
                        y = 0;
                    elseif x==0 && y==1 %(0,1)处提取数据10→(0,0)
                        t = t + 2; 
                        exD(t-1) = 1;
                        exD(t) = 0;
                        x = 0; 
                        y = 0;                    
                    elseif x<=1 && y>=2 %x=0处提取0,x=1处提取1
                        t = t + 1;
                        exD(t) = x;
                        x = 0;  %(x,y)→(0,y-1)
                        y = y-1;
                    elseif x>=2 && y<=1 %y=0处提取0,y=1处提取1
                        t = t + 1;
                        exD(t) = y;
                        x = x-1;  %(x,y)→(x-1,0)
                        y = 0;
                    else  %剩下的点全部左下方向平移一位  
                        x = x - 1; 
                        y = y - 1;
                    end 
                %所有向量分四块，第2块
                elseif x <= -1 && y >= 0 
                    if (x==-2 && y==1) || (x==-1 && y==0) %(-2,1)和(-1,0)处提取数据0
                        t = t + 1;
                        exD(t) = 0;
                    elseif x==-3 && y==2 %(-3,2)处提取数据1→(-2,1)
                        t = t + 1;
                        exD(t) = 1;
                        x = -2; 
                        y = 1;  
                    elseif x==-2 && y==0 %(-2,0)处提取数据1→(-1,0)      
                        t = t + 1;   
                        exD(t) = 1;      
                        x = -1; 
                        y = 0;
                    elseif x==-1 && y==1 %(-1,1)处提取数据10→(-1,0)
                        t = t + 2; 
                        exD(t-1) = 1;
                        exD(t) = 0;
                        x = -1;
                        y = 0;                    
                    elseif x>=-2 && y>=2 %x=-1处提取0,x=-2处提取1
                        t = t + 1;
                        exD(t) = -x-1;
                        x = -1;  %(x,y)→(-1,y-1)
                        y = y-1;
                    elseif x<=-3 && y<=1 %y=0处提取0,y=1处提取1
                        t = t + 1;
                        exD(t) = y;
                        x = x+1;  %(x,y)→(x+1,0)
                        y = 0;
                    else  %剩下的点全部右下方向平移一位  
                        x = x + 1; 
                        y = y - 1;
                    end
                %所有向量分四块，第3块
                elseif x <= -1 && y <= -1 
                    if (x==-2 && y==-2) || (x==-1 && y==-1) %(-2,-2)和(-1,-1)处提取数据0
                        t = t + 1;
                        exD(t) = 0;
                    elseif x==-3 && y==-3 %(-3,-3)处提取数据1→(-2,-2)
                        t = t + 1;
                        exD(t) = 1;
                        x = -2; 
                        y = -2;   
                    elseif x==-2 && y==-1 %(-2,-1)处提取数据1→(-1,-1)
                        t = t + 1; 
                        exD(t) = 1;
                        x = -1; 
                        y = -1; 
                    elseif x==-1 && y==-2 %(-1,-2)处提取数据10→(-1,-1)
                        t = t + 2; 
                        exD(t-1) = 1;
                        exD(t) = 0;
                        x = -1; 
                        y = -1;                    
                    elseif x>=-2 && y<=-3 %x=-1处提取0,x=-2处提取1
                        t = t + 1;
                        exD(t) = -x-1;
                        x = -1;  %(x,y)→(-1,y+1)
                        y = y+1;
                    elseif x<=-3 && y>=-2 %y=-1处提取0,y=-2处提取1
                        t = t + 1;
                        exD(t) = -y-1;
                        x = x+1;  %(x,y)→(x+1,-1)
                        y = -1;
                    else  %剩下的点全部右上方向平移一位  
                        x = x + 1; 
                        y = y + 1;
                    end
                %所有向量分四块，第4块
                elseif x >= 0 && y <= -1 
                    if (x==1 && y==-2) || (x==0 && y==-1) %(1,-2)和(0,-1)处提取数据0
                        t = t + 1;
                        exD(t) = 0;
                    elseif x==2 && y==-3 %(2,-3)处提取数据1→(1,-2)
                        t = t + 1;
                        exD(t) = 1;
                        x = 1; 
                        y = -2;  
                    elseif x==1 && y==-1 %(1,-1)处提取数据1→(0,-1)
                        t = t + 1;    
                        exD(t) = 1;  
                        x = 0; 
                        y = -1; 
                    elseif x==0 && y==-2 %(0,-2)处提取数据10→(0,-1)
                        t = t + 2; 
                        exD(t-1) = 1;
                        exD(t) = 0;
                        x = 0;
                        y = -1;                    
                    elseif x<=1 && y<=-3 %x=0处提取0,x=1处提取1
                        t = t + 1;
                        exD(t) = x;
                        x = 0;  %(x,y)→(0,y+1)
                        y = y+1;
                    elseif x>=2 && y>=-2 %y=-1处提取0,y=-2处提取1
                        t = t + 1;
                        exD(t) = -y-1;
                        x = x-1;  %(x,y)→(x-1,-1)
                        y = -1;
                    else  %剩下的点全部左上方向平移一位  
                        x = x - 1; 
                        y = y + 1;
                    end
                end
                recover_I(i,j) = diaPV_I(i,j) + x; 
                recover_I(i+2,j) = diaPV_I(i+2,j) + y;
            end
        end
    end
end
%% 在(1,1)位置开始的菱形区域提取信息
[diaPV_I,diaPE_I] = diamond(recover_I); 
t = 0;  %计数 
for i=1:m  
    if mod(i,4)==3 || mod(i,4)==0     
        continue; %跳过已提取数据的行   
    elseif i+2 > m    
        break; %无对应向量，结束；防止行越界 
    end
    for j=1:n 
        if t == num  %提取完毕      
            break; 
        end
        if mod(i+j,2) ~= 0
            continue; %跳过该点
        else %选取(1,1)、(1,3)、（2,2）等点 
            x = diaPE_I(i,j); %构建一对预测误差向量（x,y） 
            y = diaPE_I(i+2,j);    
            %所有向量分四块，第1块              
            if x >= 0 && y >= 0    
                if (x==1 && y==1) || (x==0 && y==0) %(1,1)和(0,0)处提取数据0    
                    t = t + 1;
                    exD(t) = 0;
                elseif x==2 && y==2 %(2,2)处提取数据1→(1,1)
                    t = t + 1;  
                    exD(t) = 1;  
                    x = 1; 
                    y = 1; 
                elseif x==1 && y==0 %(1,0)处提取数据1→(0,0)
                    t = t + 1;  
                    exD(t) = 1;  
                    x = 0; 
                    y = 0; 
                elseif x==0 && y==1 %(0,1)处提取数据10→(0,0)   
                    t = t + 2; 
                    exD(t-1) = 1;        
                    exD(t) = 0;  
                    x = 0; 
                    y = 0;                    
                elseif x<=1 && y>=2 %x=0处提取0,x=1处提取1  
                    t = t + 1;
                    exD(t) = x;  
                    x = 0;  %(x,y)→(0,y-1)
                    y = y-1;
                elseif x>=2 && y<=1 %y=0处提取0,y=1处提取1 
                    t = t + 1;
                    exD(t) = y;   
                    x = x-1;  %(x,y)→(x-1,0)  
                    y = 0;
                else  %剩下的点全部左下方向平移一位     
                    x = x - 1;    
                    y = y - 1; 
                end 
            %所有向量分四块，第2块
            elseif x <= -1 && y >= 0 
                if (x==-2 && y==1) || (x==-1 && y==0) %(-2,1)和(-1,0)处提取数据0  
                    t = t + 1;   
                    exD(t) = 0; 
                elseif x==-3 && y==2 %(-3,2)处提取数据1→(-2,1)  
                    t = t + 1;   
                    exD(t) = 1;  
                    x = -2; 
                    y = 1;   
                elseif x==-2 && y==0 %(-2,0)处提取数据1→(-1,0)      
                    t = t + 1;   
                    exD(t) = 1;      
                    x = -1; 
                    y = 0;
                elseif x==-1 && y==1 %(-1,1)处提取数据10→(-1,0)   
                    t = t + 2;  
                    exD(t-1) = 1;   
                    exD(t) = 0;
                    x = -1; 
                    y = 0;                    
                elseif x>=-2 && y>=2 %x=-1处提取0,x=-2处提取1  
                    t = t + 1;
                    exD(t) = -x-1;           
                    x = -1;  %(x,y)→(-1,y-1)     
                    y = y-1;
                elseif x<=-3 && y<=1 %y=0处提取0,y=1处提取1
                    t = t + 1;
                    exD(t) = y;  
                    x = x+1;  %(x,y)→(x+1,0) 
                    y = 0;
                else  %剩下的点全部右下方向平移一位           
                    x = x + 1;        
                    y = y - 1; 
                end 
            %所有向量分四块，第3块   
            elseif x <= -1 && y <= -1 
                if (x==-2 && y==-2) || (x==-1 && y==-1) %(-2,-2)和(-1,-1)处提取数据0
                    t = t + 1; 
                    exD(t) = 0;
                elseif x==-3 && y==-3 %(-3,-3)处提取数据1→(-2,-2)    
                    t = t + 1;   
                    exD(t) = 1;  
                    x = -2; 
                    y = -2;   
                elseif x==-2 && y==-1 %(-2,-1)处提取数据1→(-1,-1)
                    t = t + 1; 
                    exD(t) = 1;
                    x = -1; 
                    y = -1; 
                elseif x==-1 && y==-2 %(-1,-2)处提取数据10→(-1,-1)
                    t = t + 2; 
                    exD(t-1) = 1;  
                    exD(t) = 0;   
                    x = -1; 
                    y = -1;                    
                elseif x>=-2 && y<=-3 %x=-1处提取0,x=-2处提取1 
                    t = t + 1;
                    exD(t) = -x-1;   
                    x = -1;  %(x,y)→(-1,y+1)     
                    y = y+1;
                elseif x<=-3 && y>=-2 %y=-1处提取0,y=-2处提取1 
                    t = t + 1;
                    exD(t) = -y-1;  
                    x = x+1;  %(x,y)→(x+1,-1) 
                    y = -1;
                else  %剩下的点全部右上方向平移一位   
                    x = x + 1;    
                    y = y + 1;
                end
            %所有向量分四块，第4块
            elseif x >= 0 && y <= -1 
                if (x==1 && y==-2) || (x==0 && y==-1) %(1,-2)和(0,-1)处提取数据0     
                    t = t + 1;    
                    exD(t) = 0;
                elseif x==2 && y==-3 %(2,-3)处提取数据1→(1,-2)  
                    t = t + 1;  
                    exD(t) = 1;   
                    x = 1; 
                    y = -2; 
                elseif x==1 && y==-1 %(1,-1)处提取数据1→(0,-1)
                    t = t + 1;    
                    exD(t) = 1;  
                    x = 0; 
                    y = -1; 
                elseif x==0 && y==-2 %(0,-2)处提取数据10→(0,-1)
                    t = t + 2;    
                    exD(t-1) = 1;   
                    exD(t) = 0; 
                    x = 0; 
                    y = -1;                    
                elseif x<=1 && y<=-3 %x=0处提取0,x=1处提取1  
                    t = t + 1;
                    exD(t) = x;
                    x = 0;  %(x,y)→(0,y+1)
                    y = y+1;    
                elseif x>=2 && y>=-2 %y=-1处提取0,y=-2处提取1
                    t = t + 1;
                    exD(t) = -y-1; 
                    x = x-1;  %(x,y)→(x-1,-1)   
                    y = -1;
                else  %剩下的点全部左上方向平移一位    
                    x = x - 1;    
                    y = y + 1;
                end  
            end
            recover_I(i,j) = diaPV_I(i,j) + x;    
            recover_I(i+2,j) = diaPV_I(i+2,j) + y; 
        end 
    end
end