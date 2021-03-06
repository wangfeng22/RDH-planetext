function [rec_blockdct,exData,pos]=extract(rec_blockdct,exData,pos,payload,row,col,Cv,exchange_table,R)   
%函数功能：提取恢复函数，对位于(row,col)的块进行数据提取
%返回值rec_blockdct为恢复后的dct矩阵，返回值pos表示已提取多少数据

[Z_dct]=GetZigzag(rec_blockdct{row,col});      %得到位于(row,col)的块的Zigzag序列

for i=1:32
        if R(i,1)==1
            continue;
        end
        if pos>=payload || i>Cv            %整个数据全部提取或选择的位置已全部提取，则跳出循环
             break
        end
       
        %两个相邻的系数进行配对，根据交换表的值选择结合方式
        if exchange_table(1,R(i,1))==0    
           x=Z_dct(1,2*R(i,1)-1);
           y=Z_dct(1,2*R(i,1));
        else
           x=Z_dct(1,2*R(i,1));
           y=Z_dct(1,2*R(i,1)-1); 
        end
        
         %所有向量分四块，第1块
        if x>0 && y>=0                      
            if (x==2 && y==1) || (x==2 && y==0)    %(2,1)和(2,0)处提取数据1→(1,1) (1,0)
                pos=pos+1;
                exData(pos)=1;
                x=x-1;
            elseif x>1 && y==2                      %(x,2)处提取数据1→(x,1)
                pos=pos+1;
                exData(pos)=1;
                y=y-1;
            elseif (x==1 && y==1) || (x==1 && y==0)      %(1,1)和(1,0)处提取数据0→(1,1) (1,0)
                pos=pos+1;
                exData(pos)=0;
            elseif x>2 && y==1                       %(x,1)处提取数据0→(x-1,0)
                pos=pos+1;
                exData(pos)=0;
                x=x-1;
            elseif x==1 && y==2              %(1,2)处提取数据10→(1,1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y-1;
            elseif x>2 && y==0      %(x,0)→(x-1,0)
                x=x-1;
            else                     %(x,y)→(x,y-1)
                y=y-1;
            end
          
        %所有向量分四块，第2块
        elseif x<=0 && y>0                  
            if x==-2 && y==1                 %(-2,1)处提取数据1→(-1,1)
                pos=pos+1;
                exData(pos)=1;
                x=x+1;
            elseif (x==0 && y==2) || (x<-1 && y==2)       %(0,2)和(x,2)处提取数据1→(0,1) (x,1)
                pos=pos+1;
                exData(pos)=1;
                y=y-1;
            elseif (x==-1 && y==1) || (x==0 && y==1)    %(-1,1)和(0,1)处提取数据0→(-1,1) (0,1)
                pos=pos+1;
                exData(pos)=0;
            elseif x<-2 && y==1        %(x,1)处提取数据0→(x+1,0)
                pos=pos+1;
                exData(pos)=0;
                x=x+1;
            elseif x==-1 && y==2           %(-1,2)处提取数据10→(-1,1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y-1;
            else                         %(x,y)→(x,y-1)
                y=y-1;
            end
            
        %所有向量分四块，第3块    
        elseif x<0 && y<=0               
            if (x==-2 && y==-1) || (x==-2 && y==0)                   %(-2,-1)和(-2,0)处提取数据1→(-1,-1) (-1,0)
                pos=pos+1;
                exData(pos)=1;
                x=x+1;
            elseif x<-1 && y==-2      %(x,-2)处提取数据1→(x,-1)
                pos=pos+1;
                exData(pos)=1;
                y=y+1;
            elseif (x==-1 && y==-1) || (x==-1 && y==0)              %(-1,-1)和(-1,0)处提取数据0→(-1,-1) (-1,0)
                pos=pos+1;
                exData(pos)=0;
            elseif x<-2 && y==-1       %(x,-1)处提取数据0→(x+1,-1)
                pos=pos+1;
                exData(pos)=0;
                x=x+1;
            elseif x==-1 && y==-2     %(-1,-2)处提取数据10→(-1,-1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y+1;
            elseif x<-2 && y==0         %(x,0)→(x+1,0)
                x=x+1;
            else                 %(x,y)→(x,y+1)
                y=y+1;
            end
            
        %所有向量分四块，第4块     
        elseif x>=0 && y<0    
            if x==2 && y==-1          %(2,-1)处提取数据1→(1,-1)
                pos=pos+1;
                exData(pos)=1;
                x=x-1; 
            elseif (x==0 && y==-2) || (x>1 && y==-2)    %(0,-2)和(x,-2)处提取数据1→(0,-1) (x,-1)
                pos=pos+1;
                exData(pos)=1;
                y=y+1;
            elseif (x==0 && y==-1) || (x==1 && y==-1)   %(0,-1)和(1,-1)处提取数据0→(0,-1) (1,-1)
                pos=pos+1;
                exData(pos)=0;
            elseif x>2 && y==-1    %(x,-1)处提取数据0→(x-1,-1)
                pos=pos+1;
                exData(pos)=0;
                x=x-1;
            elseif x==1 && y==-2    %(1,-2)处提取数据10→(1,-1)
                pos=pos+2;
                exData(pos-1)=1;
                exData(pos)=0;
                y=y+1;
            else           %(x,y)→(x,y+1)
                y=y+1;
            end
        end
        
        if exchange_table(1,R(i,1))==0
           Z_dct(1,2*R(i,1)-1)=x;
           Z_dct(1,2*R(i,1))=y;
        else
           Z_dct(1,2*R(i,1)-1)=y;
           Z_dct(1,2*R(i,1))=x;
        end
end

[rec_blockdct{row,col}]=AntiZigzag(Z_dct);   %将一维的Zigzag序列转为8X8的块

if pos>payload
    exData=exData(1,1:payload);
end

end
                
                
                