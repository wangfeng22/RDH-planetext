function [exD,jpeg_info_recover] = extract(num,jpeg_info_stego)
%Tz表示设定的阈值，num是嵌入数据的数量，jpeg_info_stego表示载密jpeg图像的信息
jpeg_info_recover = jpeg_info_stego; %构建存储恢复jpeg图像的容器
dct_coef = jpeg_info_stego.coef_arrays{1,1}; %获取dct系数
[m,n]=size(dct_coef); %统计dct系数的行列数
exD = zeros(1,num);
num_exD = 0; %计数，已提取数据的数量
for i=1:m
    for j=1:n
        if(num_exD == num) %数据提取完毕           
            break;
        elseif (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数 
            if dct_coef(i,j) == 0                                   
                continue;   %遍历ac系数为0时不做改变               
            elseif dct_coef(i,j) > 2                                 
                dct_coef(i,j)=dct_coef(i,j)-1;    
            elseif dct_coef(i,j) < -2                                  
                dct_coef(i,j)=dct_coef(i,j)+1;             
            elseif dct_coef(i,j) == -2            
                num_exD = num_exD + 1;     
                exD(num_exD) = 1;           
                dct_coef(i,j)=dct_coef(i,j)+1;         
            elseif dct_coef(i,j) == 2          
                num_exD = num_exD + 1;           
                exD(num_exD) = 1;         
                dct_coef(i,j)=dct_coef(i,j)-1;    
            elseif dct_coef(i,j)==-1 || dct_coef(i,j)==1         
                num_exD = num_exD + 1;          
                exD(num_exD) = 0;          
            end                   
        end
    end
end
jpeg_info_recover.coef_arrays{1,1} = dct_coef;
end