function  [ex_Data,num]=Data_extract(stego_dct_coef,payload,k,i,j)  %提取数据
ex_Data=zeros(1,64)-1;
num=0;
for a=0:7
  for b=0:7
    if k+num==payload
       break;
    end
      if a~=0||b~=0  %去掉dc系数
        if stego_dct_coef(i+a,j+b) ~= -1 && stego_dct_coef(i+a,j+b) ~= 0 && stego_dct_coef(i+a,j+b) ~= 1 %排除为-1，0 ，1的ac系数
             if  mod(stego_dct_coef(i+a,j+b),2)==0
              ex_Data(1+num)=0;
             else
              ex_Data(1+num)=1;
             end
             num=num+1;
        end
      end
  end
end