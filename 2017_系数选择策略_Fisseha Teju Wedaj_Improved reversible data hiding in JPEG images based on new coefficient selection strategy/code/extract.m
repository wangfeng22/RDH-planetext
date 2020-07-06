function [recBlockdct,exData,pos]=extract(recBlockdct,exData,pos,payload,positions,row,col)
len=length(positions);
flag=0;
for i=1:len
    if abs(recBlockdct{row,col}(positions(i)+1))==2
        exData(pos)=1;
        if pos==payload
            flag=1;
        end
        pos=pos+1;
    elseif abs(recBlockdct{row,col}(positions(i)+1))==1
        exData(pos)=0;
        if pos==payload
            flag=1;
        end
        pos=pos+1;
    end
    if recBlockdct{row,col}(positions(i)+1)>1
        recBlockdct{row,col}(positions(i)+1)=recBlockdct{row,col}(positions(i)+1)-1;
    elseif recBlockdct{row,col}(positions(i)+1)<-1
        recBlockdct{row,col}(positions(i)+1)=recBlockdct{row,col}(positions(i)+1)+1;
    else
        recBlockdct{row,col}(positions(i)+1)=recBlockdct{row,col}(positions(i)+1);
    end
    if flag==1
        break;
    end
end
end