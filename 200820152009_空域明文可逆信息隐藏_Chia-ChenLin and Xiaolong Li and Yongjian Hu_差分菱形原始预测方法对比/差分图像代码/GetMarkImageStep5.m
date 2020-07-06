function Mark=GetMarkImageStep5(I,Embed,lsum,A,B)
Mark=I;
[row,col]=size(I);
%分成多少行多少列
deltlie=floor(col/B);
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
                if I(hang,lie) <= I(hang,lie+1)
                    Mark(hang,lie)=I(hang,lie);
                else
                    Mark(hang,lie)=I(hang,lie+1)+Embed(i,hang-qishihang+1,1);
                end
            elseif (lie-qishilie)==1
                if I(hang,lie)>=I(hang,lie-1)
                    Mark(hang,lie)=I(hang,lie-1)+Embed(i,hang-qishihang+1,1);
                else
                    Mark(hang,lie)=I(hang,lie);
                end
            else
                if I(hang,lie-1)<=I(hang,lie)
                   Mark(hang,lie)=Mark(hang,lie-1)+Embed(i,hang-qishihang+1,lie-qishilie);
                else
                   Mark(hang,lie)=Mark(hang,lie-1)-Embed(i,hang-qishihang+1,lie-qishilie);
                end
            end
        end
    end
end