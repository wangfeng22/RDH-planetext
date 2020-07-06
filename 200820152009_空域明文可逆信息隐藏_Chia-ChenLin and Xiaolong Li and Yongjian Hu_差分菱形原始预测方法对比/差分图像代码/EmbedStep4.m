function [D,lend]=EmbedStep4(WE,I,S,peak,lstart,Pixelnum,A,B)
for i=1:A
    if lstart>Pixelnum
        break;
    end
    for j=1:B-1
        if I(WE,i,j)==peak
            I(WE,i,j)=I(WE,i,j)+S(lstart);
            lstart=lstart+1;
            if lstart>Pixelnum
                break;
            end
        end
    end
    if lstart>Pixelnum
        break;
    end
end
D=I;
lend=lstart;