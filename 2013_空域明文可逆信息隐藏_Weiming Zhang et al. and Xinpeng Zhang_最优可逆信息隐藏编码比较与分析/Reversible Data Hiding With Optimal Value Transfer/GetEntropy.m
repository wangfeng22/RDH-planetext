function y = GetEntropy(X)%ÇóìØº¯Êý

y = 0;
sumx = sum(abs(X));
for k = 1:length(X)
    if abs(X(k))>0
        temp = X(k)/sumx;
        y = y - temp*log(temp)/log(2);
    end
end
y = y * sumx;
       
