function [stegoBlockdct,pos]=embed(stegoBlockdct,Data,pos,positions,row,col)
payload=length(Data);
len=length(positions);
for i=1:len
    if stegoBlockdct{row,col}(positions(i)+1)==1
        stegoBlockdct{row,col}(positions(i)+1)=stegoBlockdct{row,col}(positions(i)+1)+Data(pos);
        if pos==payload
            break;
        end
        pos=pos+1;
    elseif stegoBlockdct{row,col}(positions(i)+1)==-1
        stegoBlockdct{row,col}(positions(i)+1)=stegoBlockdct{row,col}(positions(i)+1)-Data(pos);
        if pos==payload
            break;
        end
        pos=pos+1;
    elseif stegoBlockdct{row,col}(positions(i)+1)>1
        stegoBlockdct{row,col}(positions(i)+1)=stegoBlockdct{row,col}(positions(i)+1)+1;
    elseif stegoBlockdct{row,col}(positions(i)+1)<-1
        stegoBlockdct{row,col}(positions(i)+1)=stegoBlockdct{row,col}(positions(i)+1)-1;
    else
        stegoBlockdct{row,col}(positions(i)+1)=stegoBlockdct{row,col}(positions(i)+1);
    end
end
end