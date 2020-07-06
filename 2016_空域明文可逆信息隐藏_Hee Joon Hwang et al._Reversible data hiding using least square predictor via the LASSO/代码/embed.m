function [stego_I,emD,emD_num]=embed(origin_I,data)
oriP_I=origin_I;%预测值
oriPE_I=origin_I;%预测误差
stego_I=origin_I;
[row,col]=size(origin_I);
num=length(data);
emD=zeros(1,num);
emD_num=0;
%local_v_I=origin_I;
%local_v_II=origin_I;
%% 定义训练集，支持像素的大小
L=5; 
N=8;
M=(2*L*(L+1))/2;
Y=zeros(M,1);
X=zeros(M,N);
%E=zeros(M,N);
%W=zeros(N,1);
%%  求解局部方差
%for i=2;row-1
   % for j=2;col-1
    % local_v_II(i,j)=floor((origin_I(i-1,j)+origin_I(i,j-i)+origin_I(i,j)+origin_I(i+1,j)+origin_I(i,j+1))/5);
     %local_v_I=((origin_I(i-1,j)-local_v_II(i,j))^2+(origin_I(i,j-i)-local_v_II(i,j))^2+(origin_I(i,j)-local_v_II(i,j))^2+(origin_I(i+1,j)-local_v_II(i,j))^2+(origin_I(i,j+1)-local_v_II(i,j))^2)/5;
   % end
%end
%%  先在差集上进行数据嵌入
numm=0;
for i=L+3:+1:row-1%目标像素  
    if(mod(i,2)==0)
    for j=L+3:+2:col-5
        for k=i-L:+1:i%训练集的矩阵赋值,矩阵X的赋值
            if(mod(k,2)==1)
             for h=j-L:+2:j+L-2
                 if (numm<M)
                    numm=numm+1;
                    Y(numm,1)=origin_I(k,h);%训练集中的像素
                    X(numm,1)=origin_I(k,h-1);%训练集中的支持像素
                    X(numm,2)=origin_I(k-1,h);
                    X(numm,3)=origin_I(k,h+1);
                    X(numm,4)=origin_I(k+1,h);
                    X(numm,5)=origin_I(k-1,h-2);
                    X(numm,6)=origin_I(k-2,h-1);
                    X(numm,7)=origin_I(k-2,h+1);
                    X(numm,8)=origin_I(k-1,h+2);
                 end
             end
            elseif(mod(k,2)==0)
             for h=j-L+1:+2:j+L-2
                if (numm<M)
                    numm=numm+1;
                    Y(numm,1)=origin_I(k,h);%训练集中的像素
                    X(numm,1)=origin_I(k,h-1);%训练集中的支持像素
                    X(numm,2)=origin_I(k-1,h);
                    X(numm,3)=origin_I(k,h+1);
                    X(numm,4)=origin_I(k+1,h);
                    X(numm,5)=origin_I(k-1,h-2);
                    X(numm,6)=origin_I(k-2,h-1);
                    X(numm,7)=origin_I(k-2,h+1);
                    X(numm,8)=origin_I(k-1,h+2);
                 end
             end
            end
        end 
        W=inv(X'*X)*(X'*Y);
        oriP_I(i,j)=floor(W(1,1)*origin_I(i,j-1)+W(2,1)*origin_I(i-1,j)+W(3,1)*origin_I(i,j+1)+W(4,1)*origin_I(i+1,j)+W(5,1)*origin_I(i-1,j-2)+W(6,1)*origin_I(i-2,j-1)+W(7,1)*origin_I(i-2,j+1)+W(8,1)*origin_I(i-1,j+2));
        oriPE_I(i,j)=origin_I(i,j)-oriP_I(i,j);
        if oriPE_I(i,j)<-1
              stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)-1;
          elseif oriPE_I(i,j)==-1
             emD_num=emD_num+1;
             stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)-data(emD_num);
             emD(emD_num)=data(emD_num);
          elseif oriPE_I(i,j)==0
             emD_num=emD_num+1;
             stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)+data(emD_num);
             emD(emD_num)=data(emD_num);
          elseif  oriPE_I(i,j)>0
             stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)+1;
        end
          if emD_num==num      
              break    
         end  
    end
    end
    if(mod(i,2)==1)
    for j=L+4:+2:col-5
        for k=i-L:+1:i
            if(mod(k,2)==1)
             for h=j-L:+2:j+L-2
               if (numm<M)
                    numm=numm+1;
                    Y(numm,1)=origin_I(k,h);%训练集中的像素
                    X(numm,1)=origin_I(k,h-1);%训练集中的支持像素
                    X(numm,2)=origin_I(k-1,h);
                    X(numm,3)=origin_I(k,h+1);
                    X(numm,4)=origin_I(k+1,h);
                    X(numm,5)=origin_I(k-1,h-2);
                    X(numm,6)=origin_I(k-2,h-1);
                    X(numm,7)=origin_I(k-2,h+1);
                    X(numm,8)=origin_I(k-1,h+2);
                end
             end
            elseif(mod(k,2)==0)
             for h=j-L+1:+2:j+L-2
                if (numm<M)
                    numm=numm+1;
                    Y(numm,1)=origin_I(k,h);%训练集中的像素
                    X(numm,1)=origin_I(k,h-1);%训练集中的支持像素
                    X(numm,2)=origin_I(k-1,h);
                    X(numm,3)=origin_I(k,h+1);
                    X(numm,4)=origin_I(k+1,h);
                    X(numm,5)=origin_I(k-1,h-2);
                    X(numm,6)=origin_I(k-2,h-1);
                    X(numm,7)=origin_I(k-2,h+1);
                    X(numm,8)=origin_I(k-1,h+2);
                end
             end
            end
        end 
        W=(inv(X'*X))*(X'*Y);
       oriP_I(i,j)=floor(W(1,1)*origin_I(i,j-1)+W(2,1)*origin_I(i-1,j)+W(3,1)*origin_I(i,j+1)+W(4,1)*origin_I(i+1,j)+W(5,1)*origin_I(i-1,j-2)+W(6,1)*origin_I(i-2,j-1)+W(7,1)*origin_I(i-2,j+1)+W(8,1)*origin_I(i-1,j+2));
        oriPE_I(i,j)=origin_I(i,j)-oriP_I(i,j);
        if oriPE_I(i,j)<-1
              stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)-1;
          elseif oriPE_I(i,j)==-1
             emD_num=emD_num+1;
             stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)-data(emD_num);
             emD(emD_num)=data(emD_num);
          elseif oriPE_I(i,j)==0
             emD_num=emD_num+1;
             stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)+data(emD_num);
             emD(emD_num)=data(emD_num);
          elseif  oriPE_I(i,j)>0
             stego_I(i,j)=oriP_I(i,j)+oriPE_I(i,j)+1;
         end
         if emD_num==num      
              break    
         end  
    end
    
    end
    
end
        
        
      
        
            
                
                
        
        








