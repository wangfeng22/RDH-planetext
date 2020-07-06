function all_choice=choice(k)
% k=1 all_choice={0
%                 1}
% k=2 all_choice={ 00
%                  01
%                  10
%                  11}                  
all_choice=zeros(2^k,k);
  for i=0:2^k-1
      m=i;
      for j=1:k
          all_choice(i+1,k-j+1)=mod(m,2);
          m=floor(m/2);
      end
  end