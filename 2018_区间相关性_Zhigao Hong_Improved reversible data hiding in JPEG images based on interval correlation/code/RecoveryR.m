function [R]=RecoveryR(AC,q,cs)
R=0;
for i=1:cs
    if AC(i)==0
        R=R+2/(q*q);
    end
end
end