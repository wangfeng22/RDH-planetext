function peak=GetPeak(P)
mx=1;
for i=2:256
    if P(i)>P(mx)
        mx=i;
    end
end
mx=mx-1;
peak=mx;