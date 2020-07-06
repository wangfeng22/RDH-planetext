function [rec_best]=RecoveryBest(AC_matrix,quant_tables,cs)
cnt=1;
for i=1:63
    for j=1:cs:4096
        rec_best(cnt,1)=i;
        rec_best(cnt,2)=j;
        rec_best(cnt,3)=RecoveryR(AC_matrix(i,j:j+cs-1),quant_tables(i+1),cs);
        cnt = cnt+1;
    end
end
rec_best = sortrows(rec_best,-3);
end