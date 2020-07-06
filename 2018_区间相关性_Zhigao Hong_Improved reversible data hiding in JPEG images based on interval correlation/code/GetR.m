function [R,num1,distortion]=GetR(AC,q,cs)
R=0;num1=0;numx=0;
for i=1:cs
    if AC(i)==0
        R=R+2/(q*q);
    elseif abs(AC(i))==1
        num1=num1+1;
    else numx=numx+1;
    end
end
distortion = (numx+num1/2)*q*q;
end