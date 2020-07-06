function P=GetHis(I)
P=zeros(1,511);
for i=1:numel(I)
    P(I(i)+256)=P(I(i)+256)+1;
end
% plot(P);