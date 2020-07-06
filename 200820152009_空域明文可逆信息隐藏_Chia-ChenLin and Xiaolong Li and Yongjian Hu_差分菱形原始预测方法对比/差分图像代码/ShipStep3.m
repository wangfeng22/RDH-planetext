function Q=ShipStep3(P,W,lsum,A,B)
Q=P;
for i=1:lsum
    for row=1:A
        for col=1:B-1
            if P(i,row,col)>W(i)
                Q(i,row,col)=Q(i,row,col)+1;
            end
        end
    end
end
