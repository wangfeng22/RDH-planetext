function [numData2,stego_jpeg_info,extData] = jpeg_extract(stego_jpeg_info,payload)
dct_coef = stego_jpeg_info.coef_arrays{1,1};
[m,n] = size(dct_coef);
numData2 = 0;
extData = zeros();
for i = 1:m
    for j = 1:n
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数
            if dct_coef(i,j) ~= 0 %排除为0 的ac系数
                if numData2 == 15000
                    break;
                end
                if (dct_coef(i,j) > 0 &&  mod(dct_coef(i,j),2)==0)
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = dct_coef(i,j)/2;
                    extData(numData2) = 0;
                elseif (dct_coef(i,j) > 0 &&  mod(dct_coef(i,j),2)~=0)
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = (dct_coef(i,j)-1)/2;
                    extData(numData2) = 1;
                elseif (dct_coef(i,j) < 0 &&  mod(dct_coef(i,j),2)==0)
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = dct_coef(i,j)/2;
                    extData(numData2) = 0;
                elseif (dct_coef(i,j) < 0 &&  mod(dct_coef(i,j),2)~=0)
                    numData2 = numData2 + 1;
                    dct_coef(i,j) = (dct_coef(i,j) +1)/2;
                    extData(numData2) = 1;
                end
            end
        end
    end
end
stego_jpeg_info.coef_arrays{1,1} = dct_coef;
end