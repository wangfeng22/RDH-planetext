function y=fun_add_zero(y)
a=find(y==255);
for i=1:length(a)
     k=a(length(a)+1-i,1);
    z=[y(1:k,1);0;y(k+1:length(y),1)];
    y=z;
end
end
