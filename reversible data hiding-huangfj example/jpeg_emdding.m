function [emdData,numData,ACmatrix,index] = jpeg_emdding(Data,ACmatrix,payload)
numData = 0;
%根据0的个数从大到小排序，优先嵌入0个数多的块。
temp=ACmatrix;
for i=1:63;
    for j=1:4096;
        if ACmatrix(i,j)==0;
            temp(i,j)=1;
        else
            temp(i,j)=0;
        end
    end
end
temp=sum(temp);%一维数组，1-4096列0的个数
[~,index]=sort(temp,'descend');
%开始嵌入,按照零的个数从大到小
for i = 1:4096;
     for j = 1:63
            if ACmatrix(j,index(i)) ~= 0 %排除为0 的ac系数
                if numData == payload
                    break;
                end
                if ACmatrix(j,index(i)) > 1
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) +1;
                elseif ACmatrix(j,index(i)) < -1
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) -1;
                elseif ACmatrix(j,index(i)) == 1
                    numData = numData + 1;
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) + Data(numData);
                elseif ACmatrix(j,index(i)) == -1
                    numData = numData + 1;
                    ACmatrix(j,index(i)) = ACmatrix(j,index(i)) - Data(numData);
                end
            end
        end
    end

emdData = Data(1:numData);%嵌入的数据
end