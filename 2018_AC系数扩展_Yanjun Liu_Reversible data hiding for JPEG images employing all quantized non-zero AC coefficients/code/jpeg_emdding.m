 function [emdData,numData,jpeg_info_stego] = jpeg_emdding(Data,dct_coef,jpeg_info,payload)
jpeg_info_stego = jpeg_info;
[m,n] = size(dct_coef);
numData = 0;
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数
            if dct_coef(i,j) ~= 0 %排除为0 的ac系数
                if numData == 15000
                    break;
                end
                if dct_coef(i,j) > 0
                     numData = numData + 1;
                    dct_coef(i,j) = dct_coef(i,j)*2+Data(numData);
                elseif dct_coef(i,j) < 0
                     numData = numData + 1;
                    dct_coef(i,j) = dct_coef(i,j)*2-Data(numData);
                end
            end
        end
    end
end
jpeg_info_stego.coef_arrays{1,1} = dct_coef;
emdData = Data(1:numData);%嵌入的数据
end