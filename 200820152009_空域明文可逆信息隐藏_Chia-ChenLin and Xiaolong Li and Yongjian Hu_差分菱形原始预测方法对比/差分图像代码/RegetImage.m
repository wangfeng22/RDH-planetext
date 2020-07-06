function RH=RegetImage(RD,Mark,I,lsum,A,B)
[row,col]=size(I);
RH=zeros(row,col);
%分成多少行多少列
deltlie=col/B;
for i=1:lsum
    hang1= floor((i-1)/deltlie);
    qishihang=hang1*A+1;
    lie1 = mod(i,deltlie)-1;
    if lie1<0
        lie1=lie1+deltlie;
    end
    qishilie=lie1*B+1;
    for hang=qishihang:(qishihang+A-1)
        for lie=qishilie:(qishilie+B-1)
            if (lie-qishilie)==0
                if Mark(hang,lie) <= Mark(hang,lie+1)
                    RH(hang,lie)=Mark(hang,lie);
                else
                    RH(hang,lie)=Mark(hang,lie+1)+RD(i,hang-qishihang+1,1);
                end
            elseif (lie-qishilie)==1
                if Mark(hang,lie)>=Mark(hang,lie-1)
                    RH(hang,lie)=Mark(hang,lie-1)+RD(i,hang-qishihang+1,1);
                else
                    RH(hang,lie)=Mark(hang,lie);
                end
            else
                if Mark(hang,lie-1)<=Mark(hang,lie)
                   RH(hang,lie)=RH(hang,lie-1)+RD(i,hang-qishihang+1,lie-qishilie);
                else
                   RH(hang,lie)=RH(hang,lie-1)-RD(i,hang-qishihang+1,lie-qishilie);
                end
            end
        end
    end
end