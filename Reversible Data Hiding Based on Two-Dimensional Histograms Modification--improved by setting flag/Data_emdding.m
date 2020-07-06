function [dct_coef3,num]=Data_emdding(dct_coef3,Data,payload,k,i,j)
  num=0;
for a=0:7
  for b=0:7
    if k+num==payload
       break;
    end
      if a~=0||b~=0  %去掉dc系数
        if dct_coef3(i+a,j+b) ~= -1 && dct_coef3(i+a,j+b) ~= 0 && dct_coef3(i+a,j+b) ~= 1 %排除为-1，0 ，1的ac系数
             if  dct_coef3(i+a,j+b)>0
                dct_coef3(i+a,j+b)=2*(floor(dct_coef3(i+a,j+b)/2))+Data(k+1+num);
                else
                dct_coef3(i+a,j+b)=2*(ceil(dct_coef3(i+a,j+b)/2))-Data(k+1+num);
             end
             num=num+1;
        end
      end
  end
end