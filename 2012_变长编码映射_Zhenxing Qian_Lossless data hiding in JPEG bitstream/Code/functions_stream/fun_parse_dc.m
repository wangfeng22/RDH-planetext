function [k,cat]=fun_parse_dc(y,z,w)
%          k：ac比特起始位置
%        cat：每段DC附加数据长度
%          y：数据流
%          z：dc码表
%          w：dc比特起始位置
table=z;
[p,dm1]=size(table);
y1=[];
x1=[];
i=1; d=2;tmp=ones(p,1);
w=w-1;
pp=0;
while pp<1,
   % match y(i) to that of the d-th bit in the table
   tmp=tmp.*[table(:,d)==y(w+i)]; % tmp is a vector of 0 and 1 with 1 indicate a match
   if sum(tmp)==1,  % narrow down to one symbol, find it
      d=2;          % reset pointer to columns of table.
      kkt=0;
      for kk=1:length(tmp)
          if(tmp(kk)==1),kkt=kk;end
      end
      cat=kkt-1;
      tmp=ones(p,1);
      if cat==length(table)-1,i=i+1;end % Because the comparison ends in last but one column,but still a 0 is left
     if(cat ~=0)
           x1=y(w+i+1:w+i+cat);%huffman编码的DIFF值01形式
         % s1=s(1,sp:sp+cat-1); 
         % y1=xor(x1,s1);
          pp=pp+1;
     else
          pp=pp+1;
      end
      i=i+cat;
   else 
      d=d+1; 
   end
   i=i+1; 
end
k=i+w;

