function  dct_coef2=bolck_xiaoyin(dct_coef2,all_choice,all_location,k,i,j) %得到块效应最小的预测块
dct_coef5=dct_coef2;
dct_coef6=dct_coef2;
sum=20000;
sum2=0;
  for a=1:2^k
      for b=1:k
      dct_coef5(all_location(b,1),all_location(b,2))=dct_coef5(all_location(b,1),all_location(b,2))+all_choice(a,b);
      end
      dct_coef4=dct_coef5(i-8:i+15,j-8:j+15);
      dct_coef3=dct_coef4(9:16,9:16);
      dct_coef4=idct2(dct_coef4);
      for c=0:7
          sum2=sum2+abs(dct_coef4(9,9+c)-dct_coef4(8,9+c))+abs(dct_coef4(9+c,16)-dct_coef4(9+c,17))+abs(dct_coef4(9+c,9)-dct_coef4(9+c,8))+abs(dct_coef4(16,9+c)-dct_coef4(17,9+c));
      end
      if sum2<sum
          dct_coef2(i:i+7,j:j+7)=dct_coef3;
          sum=sum2;
      end
      sum2=0;
      dct_coef5=dct_coef6;
  end

 
  
          
          
          