function [jpeg_info_stego,E0,E1]=emdding(Data,dct_coef,jpeg_info,payload,lsb_bit)
%% 提取每个子块非零AC系数的lsb,构成F1
lsb_num=0;
[m,n]=size(dct_coef);
F1=zeros(1,lsb_bit)-1;
 for i = 9:8:m-15
    for j = 9:8:n-15
        if lsb_num==lsb_bit
            break;
        end
        [F,num]=construc_F(dct_coef,i,j);
        if num>0
            a=1;
            while F(a)~=-1&&lsb_num~=lsb_bit
                F1(lsb_num+1)=F(a);
                lsb_num=lsb_num+1;
                a=a+1;
            end         
        end
    end
 end
%% 将LSB置零
dct_coef2=dct_coef;
for i = 9:m-8
    for j = 9:n-8
        if (mod(i,8) ~= 1) || (mod(j,8) ~= 1) %去掉dc系数
            if dct_coef2(i,j) ~= -1 && dct_coef2(i,j) ~= 0 && dct_coef2(i,j) ~= 1 %排除为-1，0 ，1的ac系数
                if  dct_coef2(i,j)>0
                dct_coef2(i,j)=2*(floor(dct_coef2(i,j)/2));
                else
                dct_coef2(i,j)=2*(ceil(dct_coef2(i,j)/2));
                end
            end
        end
    end
end
%% 进行块预测
sum=0;
for i=9:8:m-15
    for j=9:8:n-15
        [all_location,k]=location(dct_coef2,i,j);
        all_choice=choice(k);
        sum=sum+k;
        dct_coef2=bolck_xiaoyin(dct_coef2,all_choice,all_location,k,i,j);
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
        [F,num]=construc_F(dct_coef2,i,j);
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
%% 根据F2,将F1分类，得到E0，E1
E0=zeros(1,lsb_num)-1;
E1=zeros(1,lsb_num)-1;
i=0;
j=0;
for k=1:lsb_num
    if F2(k)==0
        E0(i+1)=F1(k);
        i=i+1;
    else
        E1(j+1)=F1(k);
        j=j+1;
    end
end
E0=E0(1:i);
E1=E1(1:j);
TestArith_me(E0); %压缩E0所需bits
TestArith_me(E1);
%% 嵌入数据,本应该将秘密数据和E0,E1都嵌入的，但不会写压缩编码，所以只嵌入了秘密数据
dct_coef3=dct_coef;
k=0;
for i = 9:8:m-15
    for j = 9:8:n-15
        if k==payload
            break;
        end
        [dct_coef3,num]=Data_emdding(dct_coef3,Data,payload,k,i,j);
        k=k+num;
    end
end
jpeg_info_stego=jpeg_info;
jpeg_info_stego.coef_arrays{1,1} =dct_coef3;