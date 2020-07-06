function [stego_blockdct,pos]=embed(stego_blockdct,data,pos,row,col,Cv)
%函数功能：嵌入函数，对位于(row,col)的块进行数据嵌入
%返回值stego_blockdct为嵌入后的dct矩阵，返回值pos表示已嵌入多少数据

payload=length(data);
[Z_dct]=GetZigzag(stego_blockdct{row,col});      %得到位于(row,col)的块的Zigzag序列，为一个长为64的一维数组
count=1;

for i=3:2:63
        count=count+1;
        if pos==payload || count>Cv            %满足容量或选择的频度带已满嵌，则跳出循环
             break
        end
        x=Z_dct(1,i);                               %两个相邻的系数进行配对
        y=Z_dct(1,i+1);
        
        %所有向量分四块，第1块
        if x>0 && y>=0                      
            if x==1 && y==1
                pos=pos+1;
                if pos+1<=payload         %嵌入数据还剩下2位以上
                    if data(pos)==1 && data(pos+1)==0
                        y=y+1;           %嵌入10时(1,1)→(1,2) 
                        pos=pos+1;
                    else 
                        x=x+data(pos);           %嵌入0时(1,1)→(1,1),嵌入1时(1,1)→(2,1)
                    end
                else               %只剩一位待嵌入数据
                    x=x+data(pos);
                end
            elseif x==1 && y==0     %嵌入0时(1,0)→(1,0),嵌入1时(1,0)→(2,0)
                pos=pos+1;
                x=x+data(pos);
            elseif x>1 && y==1     %嵌入0时(x,1)→(x+1,1),嵌入1时(x,1)→(x,2)
                pos=pos+1;
                if data(pos)==0
                    x=x+1;
                else
                    y=y+1;
                end
            elseif x>1 && y==0        %移位系数对(x,0)→(x+1,0)
                x=x+1;
            elseif x>0 && y>1        %移位系数对(x,y)→(x,y+1)
                y=y+1;
            end
            
        %所有向量分四块，第2块
        elseif x<=0 && y>0              
            if x==-1 && y==1
                pos=pos+1;
                if pos+1<=payload        %嵌入数据还剩下2位以上
                    if data(pos)==1 && data(pos+1)==0
                        y=y+1;                  %嵌入10时(-1,1)→(-1,2) 
                        pos=pos+1;
                    else 
                        x=x-data(pos);     %嵌入0时(-1,1)→(-1,1),嵌入1时(-1,1)→(-2,1)
                    end
                else                %只剩一位待嵌入数据
                    x=x-data(pos);
                end
            elseif x==0 && y==1     %嵌入0时(0,1)→(0,1),嵌入1时(0,1)→(0,2)
                pos=pos+1;
                y=y+data(pos);
            elseif x<-1 && y==1     %嵌入0时(x,1)→(x-1,1),嵌入1时(x,1)→(x,2)
                pos=pos+1;
                if data(pos)==0
                    x=x-1;
                else
                    y=y+1;
                end
            elseif x<=0 && y>1         %移位系数对(x,y)->(x,y+1)
                y=y+1;
            end
            
        %所有向量分四块，第3块     
        elseif x<0 && y<=0             
            if x==-1 && y==-1
                pos=pos+1;
                if pos+1<=payload              %嵌入数据还剩下2位以上
                    if data(pos)==1 && data(pos+1)==0
                        y=y-1;                %嵌入10时(-1,-1)→(-1,-2) 
                        pos=pos+1;
                    else                     %嵌入0时(-1,-1)→(-1,-1),嵌入1时(-1,-1)→(-2,-1)
                        x=x-data(pos);
                    end
                else                        %只剩一位待嵌入数据
                    x=x-data(pos);
                end
            elseif x==-1 && y==0     %嵌入0时(-1,0)→(-1,0),嵌入1时(-1,0)→(-2,0)
                pos=pos+1;
                x=x-data(pos);
            elseif x<-1 && y==-1    %嵌入0时(x,-1)→(x-1,-1),嵌入1时(x,-1)→(x,-2)
                pos=pos+1;
                if data(pos)==0
                    x=x-1;
                else 
                    y=y-1;
                end
            elseif x<-1 && y==0    %移位系数对(x,0)→(x-1,0)
                x=x-1;
            elseif x<0 && y<-1      %移位系数对(x,y)→(x,y-1)
                y=y-1;
            end
            
        %所有向量分四块，第4块   
        elseif x>=0 && y<0           
            if x==1 && y==-1
                pos=pos+1;
                if pos+1<=payload             %嵌入数据还剩下2位以上
                    if data(pos)==1 && data(pos+1)==0
                        y=y-1;              %嵌入10时(1,-1)→(1,-2)
                        pos=pos+1;
                    else             %嵌入0时(1,-1)→(1,-1),嵌入1时(1,-1)→(2,-1)
                        x=x+data(pos);
                    end
                else                %只剩一位待嵌入数据
                    x=x+data(pos);
                end
            elseif x==0 && y==-1      %嵌入0时(0,-1)→(0,-1),嵌入1时(0,-1)→(0,-2)
                pos=pos+1;
                y=y-data(pos);
            elseif x>1 && y==-1    %嵌入0时(x,-1)→(x+1,-1),嵌入1时(x,-1)→(x,-2)
                pos=pos+1;
                if data(pos)==0
                    x=x+1;
                else
                    y=y-1;
                end
            elseif x>=0 && y<-1    %移位系数对(x,y)→(x,y-1)
                y=y-1;
            end
        end
        
        Z_dct(1,i)=x;
        Z_dct(1,i+1)=y;
end

%将一维的Zigzag序列转为8X8的块
[stego_blockdct{row,col}]=AntiZigzag(Z_dct);        
end
                
                
                    
                        
        

