function [new_70,new_80,new_90,new_100]=synthesize(filename,i)  %选择图片
addpath jpegread\;
addpath utils\;
best_70=zeros(3,20000/2000);
best_80=zeros(3,24000/2000);
best_90=zeros(3,30000/2000);
best_100=zeros(3,50000/2000);
for QF=70:10:100                 %选择不同的QF进行处理
   if QF==70
       T=20000;
%        best_70=zeros(3,T/2000);
   end
   if QF==80
        T=24000;
%         best_80=zeros(3,T/2000);
   end
   if QF==90
       T=30000;
%        best_90=zeros(3,T/2000);
   end
   if QF==100
       T=50000;
%        best_100=zeros(3,T/2000);
   end
imwrite(uint8(imread(filename)),strcat('name',num2str(i),num2str(QF),'.jpg'),'jpg','quality',QF);      %在当前QF下压缩
filename1=strcat('name',num2str(i),num2str(QF),'.jpg'); 
filename2=strcat('namestego',num2str(i),num2str(QF),'.jpg');
J=imread(filename1);
%当前QF下压缩形成的图片
% 对当前的图片进行一系列处理
jobj=jpeg_read(filename1);
              %修改方案
     try
        jobj.optimize_coding = 1;
        jpeg_write(jobj,filename1);
    catch
        error('ERROR (problem with saving the stego image)');
    end
jobj=jpeg_read(filename1);                          %读入图片
dct=jobj.coef_arrays{1};                           %存dct系数 
Q_table=jobj.quant_tables{1};              %对量化表进行赋值
%%%%%%%%%%%%%%%%%%不同嵌入容量下的值%%%%%%%%%%%%%%%%%%%%%%%
for messLen=2000:2000:T         %在当前QF下的JPEG图嵌入不同的信息量
embed_bit=round(rand(1,messLen));  %当前messlen下随机产生嵌入比特
%%%%%%%%%%%%%%%%%%%%%%%%%%%尝试选择嵌入系数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PSNR=zeros(1,64);
INCRE=zeros(1,64);
Q_cost=costFun(Q_table);            %将量化表的每个因子返回到空域中看它对像素产生的影响  
bin63=get63bin(dct);          %按列抽出每个DCT块中ij位置的系数为一行，相同位置为一行形成矩阵
[outbin63,capacity63,unitdistortion63]=getuintcost63bin(bin63,Q_cost);
[unitdistortion63,sort_index]=sort(unitdistortion63);        %对失真进行排序，排序好的块系数在sort_index
for selnum=12:3:3*floor(length(sort_index)/3)                %%遍历所有selnum，根据psnr寻找最佳的块嵌入数量K
    sel_index=sort_index(1:selnum);
    M=matrix_index(sel_index);                 %产生标记矩阵M
    DCT=mark(M,dct);                           %没问题，产生选择系数后的DCT块%%%
%%%%%%%%%%%%%%模拟修改图片产生嵌入序列%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simulate_dct=simulate(DCT);         %模拟修改后的图片存贮在simulate_dct
counter_1=count(DCT,1);
counter_0=count(DCT,0);
[counter_0,sort_0]=sort(counter_0);        
table=jobj.quant_tables{1};
[order,vd_distor]=select_block2(simulate_dct,DCT,table,counter_1);   %根据模拟修改的方案贪心算法（失真大小）产生一个嵌入图片的序列,产生码流失真序列
%%%%%%%%%%%%%%%%%%%%%%%%按照嵌入序列，将信息嵌入图片%%%%%%%%%%%%%%%%%%%%%%
for r=1:length(order)                                    %寻找嵌入临界值
     if (sum(counter_1(order(1:r)))>=messLen)            %按每个块中1的数目
         order=order(1:r);
         sort_0=sort_0(1:r);        
         break;
     end
end
[stego1_dct,tag]=generate_stego(order,DCT,embed_bit,messLen);       %产生嵌入的DCT系数
if tag==1
 continue;
end
stego_dct=recoverstego(dct,stego1_dct,sel_index);         %恢复其他系数
%%%%%%%%%%%%%%%%%%%%%%%%%%用上面产生的stego.dct产生嵌入图片%%%%%%%%%%%%%%%%%%%%%%%
 jobj.coef_arrays{1} = stego_dct;                     %修改方案
    try

        jobj.optimize_coding = 1;
        jpeg_write(jobj,filename2);
    catch
        error('ERROR (problem with saving the stego image)');
    end
 %% %%%&%%%%%%%%%%%%%%%%%%%%%%%%%计算失真和码流扩张%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    I=imread(filename2);
    psnr_goad=appraise(I,J);
    fid=fopen(filename2,'rb');
                    bit1=fread(fid,'ubit1');
                fclose(fid);
                fid=fopen(filename1,'rb');
                    bit2=fread(fid,'ubit1');
                fclose(fid);
    incre_bit=length(bit1)-length(bit2);
    PSNR(selnum)=psnr_goad;
    INCRE(selnum)=incre_bit;
end
[best_psnr,index]=max(PSNR);                            %找到最好的psnr
 best_incre=INCRE(index);                               %找到最好的incre_bit
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if QF==70
 j=messLen/2000;
 best_70(:,j)=[messLen,best_psnr,best_incre];
end
if QF==80   
j=messLen/2000;   
best_80(:,j)=[messLen,best_psnr,best_incre];
end
if QF==90
j=messLen/2000;
best_90(:,j)=[messLen,best_psnr,best_incre];
end
if QF==100
j=messLen/2000;
best_100(:,j)=[messLen,best_psnr,best_incre];
end
end                %%%所有messlen嵌入完成
new_70=best_70;
new_80=best_80;
new_90=best_90;
new_100=best_100;
end

