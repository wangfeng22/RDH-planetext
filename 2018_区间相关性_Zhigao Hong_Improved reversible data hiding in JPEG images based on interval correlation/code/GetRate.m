function [num] = GetRate(best,payload,cs)
pos=cs;count=1;
num=0;
while pos<payload
    num=num+best(count,5);
    pos=pos+best(count,4);
    count=count+1;
end
end