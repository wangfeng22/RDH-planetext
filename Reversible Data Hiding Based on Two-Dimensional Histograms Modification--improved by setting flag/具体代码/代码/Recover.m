function [re_dct,exData]=Recover(stego_dct,quant_tables)
%函数功能：提取数据，并恢复图像
%返回值re_dct为恢复后的dct矩阵，exData为提取的数据

exData=zeros();
stego_blockdct = mat2cell(stego_dct,8 * ones(1,64),8 * ones(1,64));         %把dct矩阵分割成4096个8*8的Block
rec_blockdct=stego_blockdct;

%统计每个块AC系数为0的数目，并按降序排列
[zeronum]=Getzeronum(rec_blockdct);         

%根据量化表，对32个位置进行优先级排序
[R]=GetR(quant_tables);

%从AC1中提取(payload,Cv,exchange_table)
side=Get_AC1_LSBs(rec_blockdct,56);            %提取前56个AC1的最低有效位
[payload,Cv,exchange_table]=Extside(side);          %从side中提取payload,Cv,exchange_table

%提取+恢复
pos=0;
count=1;
while pos<payload  
       [rec_blockdct,exData,pos]=extract(rec_blockdct,exData,pos,payload,zeronum(count,1),zeronum(count,2),Cv,exchange_table,R);  %提取函数
       count=count+1;
end

%恢复前56个AC1的最低有效位
for i=1:56
    rec_blockdct{1,i}(1,2)=rec_blockdct{1,i}(1,2)-mod(rec_blockdct{1,i}(1,2),2)+exData(payload-56+i);
end

re_dct=cell2mat(rec_blockdct);             %从blockdct细胞矩阵获得dct矩阵

end