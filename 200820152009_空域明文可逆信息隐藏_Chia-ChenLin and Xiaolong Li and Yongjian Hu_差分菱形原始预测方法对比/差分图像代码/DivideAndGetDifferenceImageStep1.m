function [P,lsum]=DivideAndGetDifferenceImageStep1(I,A,B)
[row,col]=size(I);
lsum=floor((row/A)*(col/B));
P=zeros(lsum,A,B-1);
DJ=zeros(A,B);                                    
loc=1;
for i=1:A:row-A+1
    for j=1:B:col-B+1
        kk=1;
        ll=1;
        for k=i:i+A-1
            for l=j:j+B-1
                DJ(kk,ll)=I(k,l);
                ll=ll+1;
            end
            ll=1;
            kk=kk+1;
        end
        P(loc,:,:)=GetDifferenceImage(DJ);
        loc=loc+1;
    end
end
P=uint8(P);