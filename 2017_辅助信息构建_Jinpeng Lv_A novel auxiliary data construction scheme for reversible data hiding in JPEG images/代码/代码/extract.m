function [stego_jpeg_info,extData] = extract(stego_jpeg_info,payload,lsb_bit,E0,E1)
%% 数据提取
k=0;
extract_Data=zeros(1,payload)-1;
stego_dct_coef=stego_jpeg_info.coef_arrays{1,1};
[m,n]=size(stego_dct_coef);
for i = 9:8:m-15
    for j = 9:8:n-15
        if k==payload
            break;
        end
        [ex_Data,num]=Data_extract(stego_dct_coef,payload,k,i,j);
        if num>0
            a=1;
            while ex_Data(a)~=-1&&k~=payload
                extract_Data(k+1)=ex_Data(a);
                k=k+1;
                a=a+1;
            end         
        end
    end
end
extData=extract_Data;
%% 将LSB置零
stego_dct_coef2=stego_dct_coef;
for i = 9:m-8
    for j = 9:n-8
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数
            if stego_dct_coef2(i,j) ~= -1 && stego_dct_coef2(i,j) ~= 0 && stego_dct_coef2(i,j) ~= 1 %排除为-1，0 ，1的ac系数
                if  stego_dct_coef2(i,j)>0
                stego_dct_coef2(i,j)=2*(floor(stego_dct_coef2(i,j)/2));
                else
                stego_dct_coef2(i,j)=2*(ceil(stego_dct_coef2(i,j)/2));
                end
            end
        end
    end
end
%% 进行块预测
sum=0;
for i=9:8:m-15
    for j=9:8:n-15
        [all_location,k]=location(stego_dct_coef2,i,j);
        all_choice=choice(k);
        sum=sum+k;
        stego_dct_coef2=bolck_xiaoyin(stego_dct_coef2,all_choice,all_location,k,i,j);
        if sum>=lsb_bit
            break;
        end
    end
    if sum>=lsb_bit
            break;
     end
end
%% 提取预测LSB，构成F2
lsb_num=0;
F2=zeros(1,lsb_bit)-1;
for i = 9:8:m-15
    for j = 9:8:n-15
        if lsb_num==lsb_bit
            break;
        end
        [F,num]=construc_F(stego_dct_coef2,i,j);
        if num>0
            a=1;
            while F(a)~=-1&&lsb_num~=lsb_bit
                F2(lsb_num+1)=F(a);
                lsb_num=lsb_num+1;
                a=a+1;
            end         
        end
    end
end
%% 恢复F1
F1=zeros(1,lsb_bit)-1;
k=1;
j=1;
i=1;
while i<=lsb_bit
    if F2(i)==0
        F1(i)=E0(k);
        k=k+1;
        i=i+1;
    else
        F1(i)=E1(j);
        j=j+1;
        i=i+1;
    end
end
%% 将所选AC系数的LSB用F1替换
stego_dct_coef3=stego_dct_coef;
k=0;
for i = 9:8:m-15
    for j = 9:8:n-15
        if k==lsb_bit
            break;
        end
        [stego_dct_coef3,num]=Data_emdding(stego_dct_coef3,F1,lsb_bit,k,i,j);
        k=k+num;
    end
end
stego_jpeg_info.coef_arrays{1,1}=stego_dct_coef3;