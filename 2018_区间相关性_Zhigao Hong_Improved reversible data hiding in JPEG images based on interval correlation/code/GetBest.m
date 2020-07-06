function [best]=GetBest(AC_matrix,quant_tables,cs)
cnt=1;
for i=1:63
    for j=1:cs:4096
        best(cnt,1)=i;
        best(cnt,2)=j;
        [best(cnt,3),best(cnt,4),best(cnt,5)]=GetR(AC_matrix(i,j:j+cs-1),quant_tables(i+1),cs);
        cnt = cnt+1;
    end
end
best = sortrows(best,-3);
end