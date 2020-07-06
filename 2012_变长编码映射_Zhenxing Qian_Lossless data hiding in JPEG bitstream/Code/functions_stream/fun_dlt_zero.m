function y= fun_dlt_zero(y)
%输入y为sos段除标记等未处理的图片数据压缩部分
%输出y为去掉255之后零的图片数据压缩部分
a=find(y==255);
b=find(y(a+1,1)==0);
[m,n]=size(a);
i=0;
for j=1:m
       y(a(j,1)+1-i)=[];    
          i=i+1; 
end
  
end

