function [stegoim1,P1,P2,number0255,number0255r]=ReverEmbed(Err1,im1,HMat, Payl, Dist, drate, L, R, CHist)
%Err1是误差，im1原始的像素值，HMat是矩阵，Payl是负载，Dist是失真，drate是λ，L相当于论文的M1,R相当于论文的M2,CHist相当于论文中的h
stegoim1 = im1;
[size1,size2] = size(Err1);
HMatFold = sum(HMat);%对HMat每一列求和

P1 = 0;
P2 = 0;
P21 = 0; P22 = 0; P23 = 0; P24 = 0; P25 = 0; 
number0255 = 0;
number0255r = 0;
for i = 1:size1
    for j = 1:size2
        tempe = Err1(i,j);%每一个误差值
        tempp = im1(i,j);%误差值对应的原始像素值
        if tempe < L%如果误差值不在矩阵范围内（左边）
            tempv = tempe-L+21;%均衡误差值
            if tempv > 0
                if HMatFold(tempv) > 0
                    P21 = P21 - log(0.5/(0.5+HMatFold(tempv)))/log(2);%在L左边的误差值转换为二进制所占的位数
                end
            end
        else
            if tempe > R
                tempv = tempe-L+21;
                if tempv < length(HMatFold)+1
                    P22 = P22 - log(0.5/(0.5+HMatFold(tempv)))/log(2);%在L右边的误差值转换为二进制所占的位数
                end
            else%误差值在L与R之间
                fnz = find(HMat(tempe-L+21,:));%找到第tempe-L+21行非零元素在第tempe-L+21行的位置
                vnz = nonzeros(HMat(tempe-L+21,:));%找到第tempe-L+21行非零元素值
                vnz = vnz';
                fnz = fnz - (tempe-L+21) + tempp; %AES满足的条件，tempp是原始像素值+fnz对应的新的误差值-(tempe-L+21)原始的误差值
                if min(fnz) > 255
                    stegoim1(i,j) = 255;%标记边缘信息
                    number0255 = number0255 + 1;
                    number0255r = number0255r + 1;
                else
                    if max(fnz) < 0
                        stegoim1(i,j) = 0;%标记边缘信息
                        number0255 = number0255 + 1;
                        number0255r = number0255r + 1;
                    else%fnz在0到255之间时，下面是自适应编码的过程
                        msk1 = (sign(fnz + 0.5) + 1)/2;%转换为0、1比特
                        msk2 = (sign(255.5 - fnz) + 1)/2;
                        msk = msk1 .* msk2;%.*是数组相乘，表示逐个元素的乘法,对应位置的元素的相乘
                        fnz = msk .* fnz;%
                        vnz = msk .* vnz;
                        vnz = vnz/sum(vnz);%不饱和像素得到的新的误差的个数的概率
                        rand('seed',i*2001+j);%设置种子，每次生成稳定的随机数,保证每次产生的随机序列不相同
                        tempa = rand(1,1);%产生0到1之间的随机数
                        tempb = 0; tempc = 0;
                        while tempb < tempa
                            tempc = tempc + 1;
                            tempb = tempb + vnz(tempc);%将所有新得到的误差的概率进行累加
                        end
                        tempc;
                        P1 = P1 - log(vnz(tempc))/log(2); %所有新得到的误差所占概率转换为二进制所占的位数
                        stegoim1(i,j) = fnz(tempc);%记录下对应的像素值
                        if fnz(tempc) == 0%记录由于嵌入溢出像素值为0、255的个数
                            number0255 = number0255 + 1;
                        end
                        if fnz(tempc) == 255
                            number0255 = number0255 + 1;
                        end
                        tempd = fnz(tempc) - tempp + (tempe-L+21);%嵌入信息后得到的新的像素值
                        if tempd < 21
                            P23 = P23 - log(HMat(tempe-L+21,tempd)/(0.5+HMatFold(tempd)))/log(2);%小于L的数值所占的位数
                        else
                            if tempd > length(HMatFold) - 20
                                P24 = P24 - log(HMat(tempe-L+21,tempd)/(0.5+HMatFold(tempd)))/log(2);%大于R的数值所占的位数
                            else
                                P25 = P25 - log(HMat(tempe-L+21,tempd)/HMatFold(tempd))/log(2);%在L、R之间的数值所占的位数
                            end
                        end
                    end
                end
            end
        end
    end
end                   
% disp([P21 P22 P23 P24 P25]);
P2 = P21+P22+P23+P24+P25;
                    