function P=GetImagePeakStep2(Q,lsum)
P=zeros(1,lsum);
Z=zeros(1,256);
for i=1:lsum
    Z=GetHistogram(Q(i,:,:));
    P(i)=GetPeak(Z);
end