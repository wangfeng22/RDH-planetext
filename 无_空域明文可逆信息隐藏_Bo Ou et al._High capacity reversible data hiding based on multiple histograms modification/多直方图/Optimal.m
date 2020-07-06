function [Opt] = Optimal(Hist,num_D)  %%（有问题）
% Hist表示多直方图，num_D表示需要嵌入的数据
[~,M] = size(Hist);
Opt = zeros(2,M); %存储最优参数
a_max = 6;
%% 求第一个直方图的最大嵌入对数目
sum_max = 0;
for a=1:a_max
    for i=1:M
        sum_max = sum_max + Hist{i}((Hist{i}(:,1)==a-1),2); %(a-1,-a)为一对嵌入点
        sum_max = sum_max + Hist{i}((Hist{i}(:,1)==-a),2);
    end
    if sum_max >= num_D
        Opt(1,1) = a;
        break;
    end
end
%% 最大嵌入对为1
if Opt(1,1)==1
    for i=1:M
        Opt(1,i) = 1;
    end
    sum_1 = 0;
    for i=1:M
        for j=6:-1:0 %最外边嵌入点范围[a-1,a+5]
            EC = Hist{i}((Hist{i}(:,1)==j),2) + Hist{i}((Hist{i}(:,1)==-j-1),2);
            if sum_1+EC >= num_D
                break;
            end
        end
        sum_1 = sum_1+EC;
        if sum_1 >= num_D
            for x=1:i-1
                Opt(2,x) = 0; 
            end
            Opt(2,i) = j;  
            for x=i+1:M  
                Opt(2,x) = -1;  %-1表示无穷大
            end
            break;
        end
    end
%% 最大嵌入对大于1
else  
    Opt(2,1) = Opt(1,1)-1;
    [EC_1] = Capacity(Hist{1},Opt(1,1),Opt(2,1));   
    sum = 0;
    sum = sum + EC_1;
    for i=2:M  
        for a=1:Opt(1,i-1) %嵌入对随着直方图序号的增加而减小
            for b=a+5:-1:Opt(2,i-1) %最外边嵌入点范围[a-1,a+5],并≥上一个直方图
                EC_i = Capacity(Hist{i},a,b);
                if sum + EC_i >= num_D
                    break;
                end
            end
            if sum + EC_i >= num_D           
                break;
            end         
        end 
        Opt(1,i) = a;   
        Opt(2,i) = b;
        sum = sum + EC_i;
        if sum >= num_D
            for x=i+1:M
                Opt(1,x) = 1;
                Opt(2,x) = -1; %-1表示无穷大
            end
            break;
        end
    end
%     for j=1:Opt(1,1) %嵌入对随着直方图序号的增加而减小    
%         c = 0;
%         for i=2:M
%             c = c + Hist{i}((Hist{i}(:,1)==j-1),2) + Hist{i}((Hist{i}(:,1)==-j),2);
%             if sum+c >= num_D       
%                 end_i = i;
%                 break;
%             end
%         end
%         sum = sum + c;        
%         if sum >= num_D        
%             end_j = j;
%             break;
%         end
%     end
%     for i=2:end_i
%         Opt(1,i) = end_j;
%     end
%     for i=end_i+1:M
%         Opt(1,i) = end_j-1;
%     end  
end
%% 失真比
EC_sum = 0;
ED_sum = 0;
for i=1:M
    [EC_i] = Capacity(Hist{i}, Opt(1,i), Opt(2,i));
    EC_sum = EC_sum + EC_i;
    [ED_i] = Distortion(Hist{i}, Opt(1,i), Opt(2,i));
    ED_sum = ED_sum + ED_i;
end
ED_EC = ED_sum/ED_sum;
end
