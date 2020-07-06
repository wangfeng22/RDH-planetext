function [HMat, Payl, Dist, drate, L, R, CHist, La,temph,sumhist,OriHist,indmx] = GetHMat1(Err,NumberIteration)
%Pay1相当于文中的t（i，j）,L相当于论文中的M1，R相当于论文中的M2,drate相当于论文中的λ，NumberIteration=itenum = 10000:10000:110000
%CHist相当于文中的hk，
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

OriHist = hist(Err(:),[min(min(Err)):1:max(max(Err))]);%将矩阵中的值从小到大排列并绘制直方图，将每一种预测误差出现的次数记录在矩阵OriHist中
%figure; hist(Err(:),[min(min(Err)):1:max(max(Err))]); axis([-40 50 0 18000]); % hist(OriHist);% axis([XMIN XMAX YMIN YMAX]) sets scaling for the x- and y-axes

sumhist = sum(OriHist);%sumhist是预测误差的个数
temph = sign(OriHist - sumhist/4096);%如果结果大于零就返回1，如果等于零就返回0，如果小于零就返回-1
[vmax, indmx] = max(temph);%vmax是矩阵temph中每一列的最大值，indmx是每一列最大值的位置.就是将每一个temph为1的位置标记出来
for k = indmx:length(OriHist)
    if temph(k) == 1 
        indmx1 = k;
    end
end
%indmx是temph中1的最左侧位置；indmx1是temph中1的最右侧位置
L = min(min(Err))+indmx-1;% min(min(Err))取出Err里面的最小值，找出indmx对应的误差值是多少
R = min(min(Err))+indmx1-1;
%L相当于论文中的M1（左边界限），R相当于论文中的M2
CHist =round(OriHist/(sumhist/2048));%CHist相当于文中的hk（预测误差k对应的数量）
for k = indmx:length(CHist)
    if CHist(k) == 0
        CHist(k) = 1;
    end
end
%为了区分接下来前后加20个0
%figure; bar([1:1:92]-42, CHist, 1); axis([-22 22 0 300]);
% return

OriHist = [zeros(1,20) CHist(1,indmx:indmx1) zeros(1,20)];
%取出CHist中indmx至indmx1的数值，前后各取20个0，将数值包含在其中

%%%%%%%%%%%%%%%%%%
%将CHist中取出的数据放在OriHist 同样大小的矩阵的对角线上
LH = length(OriHist); 
HMat = zeros(LH,LH);
for k = 1:LH
    HMat(k,k) = OriHist(k);
end

delta = 1/8;
DRATE = zeros(1,NumberIteration);%用来记录每次迭代产生的λ
for k = 1:NumberIteration
    HMatFold = sum(HMat);%将HMat的每一列进行求和
    drate = 0;
    %确定论文中k的范围
    for i = 21:LH-20%LH为OriHist的长度（个数）
        for j = 21:LH-20%之所以-20是因为头尾有20个0，中间包含的才是真正的数据
            if HMat(i,j) >= delta 
                if i == j
                    jjmin = max(j-5,21);%取坐标值大的值（如j=21;jjmin=21,jjmax取两个值中比较小的值，即jjmax=j+5）
                    jjmax = min(j+5,LH-20);%取坐标值小的数值
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
                        dratetemp = dp/dd;%求论文中的λ
                        if dratetemp > drate %如果λ>0                           
                            drate = dratetemp;%将λ赋给drate
                            di = i; dj = j; djj = jj;                            
                        end
                    end
                end
            end
        end
    end
    %disp([di dj djj drate]);
    DRATE(1,k) = drate;%将每次迭代产生的λ记录下来
    HMat(di,dj) = HMat(di,dj) - delta;
    HMat(di,djj) = HMat(di,djj) + delta;%更新矩阵，从而均衡所有的λ
end  
La = mean(DRATE(1,NumberIteration-500:NumberIteration));%求从NumberIteration-500位置开始直到迭代次数为止的所有λ的均值
%plot(DRATE);
%disp([di dj djj drate]);

    Dist = 0;
    for i = 1:LH
        for j = 1:LH
            Dist = Dist + HMat(i,j)*(j-i)^2;%求失真
        end
    end
    Payl = 0;
    for i = 1:LH
        Payl = Payl + GetEntropy (HMat(i,:))
    end
    Payl;
    for j = 1:LH
        Payl = Payl - GetEntropy (HMat(:,j));%求负载
    end
   
    [Payl Dist];

    
   


