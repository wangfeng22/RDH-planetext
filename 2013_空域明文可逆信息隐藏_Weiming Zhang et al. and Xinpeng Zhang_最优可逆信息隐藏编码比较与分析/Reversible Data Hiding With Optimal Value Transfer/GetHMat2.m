function [HMat, Payl, Dist, drate, L, R, CHist] = GetHMat2(Err,La)

OriHist = hist(Err(:),[min(min(Err)):1:max(max(Err))]);

sumhist = sum(OriHist);
temph = sign(OriHist - sumhist/4096);
[vmax, indmx] = max(temph);
for k = indmx:length(OriHist)
    if temph(k) == 1
        indmx1 = k;
    end
end

L = min(min(Err))+indmx-1;
R = min(min(Err))+indmx1-1;

CHist = round(OriHist/(sumhist/2048));
for k = indmx:length(CHist)
    if CHist(k) == 0
        CHist(k) = 1;
    end
end

OriHist = [zeros(1,20) CHist(1,indmx:indmx1) zeros(1,20)];

%%%%%%%%%%%%%%%%%%
LH = length(OriHist); 
HMat = zeros(LH,LH);
for k = 1:LH
    HMat(k,k) = OriHist(k);
end



delta = 1/8;
DRATE = zeros(1,99999);
k = 0;
La1 = 200;

while La1 > La
    k = k + 1;
    HMatFold = sum(HMat);
    drate = 0;
    for i = 21:LH-20
        for j = 21:LH-20
            if HMat(i,j) >= delta 
                if i == j
                    jjmin = max(j-5,21); 
                    jjmax = min(j+5,LH-20);
                else
                    if j > i
                        jjmin = min(j+1,LH-20);
                        jjmax = min(j+5,LH-20);
                    else
                        jjmin = max(j-5,21);
                        jjmax = max(j-1,21);
                    end
                end                                   
                for jj = jjmin:jjmax  
                    dp = log(HMatFold(j)/HMatFold(jj));
                    dd = (jj-i)^2 - (j-i)^2;
                    if dp > 0
                        dratetemp = dp/dd;
                        if dratetemp > drate                            
                            drate = dratetemp;
                            di = i; dj = j; djj = jj;                            
                        end
                    end
                end
            end
        end
    end
%      disp([di dj djj drate]);
    DRATE(1,k) = drate;
    HMat(di,dj) = HMat(di,dj) - delta;
    HMat(di,djj) = HMat(di,djj) + delta;
    if k > 1000
        La1 = mean(DRATE(1,k-500:k));
    else
        La1 = 100;
    end     
end  

% plot(DRATE);
% disp([di dj djj drate]);

    Dist = 0;
    for i = 1:LH
        for j = 1:LH
            Dist = Dist + HMat(i,j)*(j-i)^2;
        end
    end
    Payl = 0;
    for i = 1:LH
        Payl = Payl + GetEntropy (HMat(i,:));
    end
    Payl;
    for j = 1:LH
        Payl = Payl - GetEntropy (HMat(:,j));
    end
    [Payl Dist];



