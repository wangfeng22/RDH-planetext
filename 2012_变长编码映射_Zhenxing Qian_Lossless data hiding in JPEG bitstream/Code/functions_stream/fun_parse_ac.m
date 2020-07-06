function [k,tblrow]=fun_parse_ac(y,table,w)
%y-原始码流 table-AC Huffman码表 w-原始码流AC系数起始位置
%    run - category - length - bsae code length -  base code
[p,dm1]=size(table);
i=1; d=5;tmp=ones(p,1);
tep=i;
w=w-1;
num=0;
ppp=0;%%%%%%
t=1;
tblrow=[];
while num<9999 && ppp<63,
   % match y(i) to that of the d-th bit in the table
   tmp=tmp.*(table(:,d)==y(w+i)); % tmp is a vector of 0 and 1 with 1 indicate a match
  if sum(tmp)==1,  % narrow down to one symbol, find it
      d=5;          % reset pointer to columns of table.
      row=find(tmp); % Index of non zero i.e 1
      tblrow(t,1)=row;%%%%%
      t=t+1;
      run=table(row,1);
      cat=table(row,2);
      i=tep+table(row,4)-1;
      tmp=ones(p,1);  % Preset temp vector
       if (run==15&cat==0),%即为零游程ZRL
         i=i+cat;       % Increment to next prefix
          tep=i+1;  
          ppp=ppp+16;%%%%%%%
      else    
         if (run==0&cat==0),
             num=9999;
             
            % y1=[y1 table(row,5:4+table(row,4))];
         else
          %num=bin2int(y(w+i+1:w+i+cat));
              %if(~(num>=2^(cat-1) && num<2^cat)),num=-1*bin2int(ones(1,cat)-y(w+i+1:w+i+cat));end
             %  x1=y(w+i+1:w+i+cat);
               %s1=s(1,sp:sp+cat-1);
              % y1=xor(x1,s1);
               %x1=[];
              % sp=sp+cat;
             %  y1=[y1 table(row,5:4+table(row,4)) y2];  
               ppp=ppp+1+run;
         end      
         i=i+cat;       % Increment to next prefix
        % x=[x zeros(1,run) num];
         tep=i+1;
      end
     
   else 
      d=d+1; 
   end
   i=i+1; 
end
k=w+i;
end