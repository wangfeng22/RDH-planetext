function [t,allbest]=GetT(AC_matrix,quant_tables,payload)
standby=[4,8,32,64];
for i=1:length(standby)
    cs = standby(i);
    best = GetBest(AC_matrix,quant_tables,cs);
    allbest(i,1)=cs;
    allbest(i,2)=GetRate(best,payload,cs);
end
allbest = sortrows(allbest,2);
t=allbest(1,1);
end