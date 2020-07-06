function [emD,jpeg_info_stego] = emdding(D,jpeg_info)
%D是要嵌入的数据，Tz表示设定的阈值，jpeg_info表示jpeg图像的信息
jpeg_info_stego = jpeg_info; %构建存储载密jpeg图像的容器
dct_coef = jpeg_info.coef_arrays{1,1}; %获取dct系数
[m,n]=size(dct_coef); %统计dct系数的行列数
num = length(D);  %嵌入数据的长度
emD = zeros(1,num);
num_emD = 0; %计数，已嵌入数据的数量
for i=1:m
    for j=1:n
        if(num_emD == num) %数据嵌入完毕             
            break;
        elseif (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数                  
            if dct_coef(i,j) == 0                                   
                continue;   %遍历ac系数为0时不做改变          
            elseif dct_coef(i,j) > 1 %大于1右移一位                               
                dct_coef(i,j)=dct_coef(i,j)+1;       
            elseif dct_coef(i,j) < -1 %小于-1左移一位                               
                dct_coef(i,j)=dct_coef(i,j)-1;     
            elseif dct_coef(i,j) == -1          
                num_emD = num_emD + 1;          
                dct_coef(i,j)=dct_coef(i,j) - D(num_emD);        
                emD(num_emD) = D(num_emD);  
            elseif dct_coef(i,j) == 1      
                num_emD = num_emD + 1;       
                dct_coef(i,j)=dct_coef(i,j) + D(num_emD);      
                emD(num_emD) = D(num_emD);         
            end                   
        end
    end
end
jpeg_info_stego.coef_arrays{1,1} = dct_coef;
end