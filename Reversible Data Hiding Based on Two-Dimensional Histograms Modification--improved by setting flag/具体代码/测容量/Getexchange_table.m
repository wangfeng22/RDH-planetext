function [exchange_table]=Getexchange_table(ori_blockdct)
%函数功能：得到交换表，为一长为32的一维数组
%交换表的元素为0，表示(AC2i-2, AC2i-1)的形式成对；交换表的元素为1，表示(AC2i-1, AC2i-2)的形式成对
 exchange_table=zeros(1,32);
 count=1;
 store_C=zeros(32,2);

for i=1:2:63                             
    
    for r=1:64
        for c=1:64
            Z_dct=GetZigzag(ori_blockdct{r,c});
            x=Z_dct(1,i);
            y=Z_dct(1,i+1);
            
            %如果(x,y)是C类型的系数对
            if abs(x)>1 && abs(y)==1      
                store_C(count,1)=store_C(count,1)+1;
            end
            
            %如果(y,x)是C类型的系数对
            if abs(y)>1 && abs(x)==1
                store_C(count,2)=store_C(count,2)+1;
            end
            
        end
    end
    
    count=count+1;
end

%第k对，如果以(y,x)成对的C类型数，要多于以(x,y)成对的C类型数，则将交换表的第k个元素置1
for i=1:32
    if store_C(i,1)<store_C(i,2)
        exchange_table(1,i)=1;
    end
end

