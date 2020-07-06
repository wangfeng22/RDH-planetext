function [AC_matrix,pos]=embed(AC_matrix,Data,pos,best,cs)
payload=length(Data);
t=best(2);
for i=t:t+cs-1
    if AC_matrix(best(1),i)==1
        AC_matrix(best(1),i)=AC_matrix(best(1),i)+Data(pos);
        if pos==payload
            break;
        end
        pos=pos+1;
    elseif AC_matrix(best(1),i)==-1
        AC_matrix(best(1),i)=AC_matrix(best(1),i)-Data(pos);
        if pos==payload
            break;
        end
        pos=pos+1;
    elseif AC_matrix(best(1),i)>1
        AC_matrix(best(1),i)=AC_matrix(best(1),i)+1;
    elseif AC_matrix(best(1),i)<-1
        AC_matrix(best(1),i)=AC_matrix(best(1),i)-1;
    end
end
end