clc;clear;
%% 读取文件
addpath('functions_stream');
addpath('D:\Matlab\ucid.v2');
fidorg = fopen('Baboon_10.jpg');
jpgData=fread(fidorg);%获取文件全部数据
[byteNum,n]= size(jpgData);
%% 提取文件头
fprintf('提取文件头...\n');
locff=find(jpgData==255);%获取JPEG文件中FF的位置
jhddata=fun_read_header(locff,jpgData);%获取文件头数据
[len,height]=size(jpgData);
for i=1:len
    if(jpgData(i,1)==0&&jpgData(i+1,1)==63&&jpgData(i+2,1)==0)
        break;
    end 
end
jpg_head=jpgData(1:i-1,:);
[height_ini, width_ini] = fun_read_sof_wh(locff,jpgData);
height_ini = height_ini(1)*256 + height_ini(2);
width_ini = (width_ini(1))*256 + width_ini(2);
%% 提取文件哈夫曼表
fprintf('提取文件哈夫曼表...\n');
locc4=find(jpgData(locff+1,1)==196);%获取huffman表  FF C4
if length(locc4)>1,
	jhuffdcdata=fun_read_dht(locff,jpgData,fidorg,1);%获取文件头中表示huffman表的部分
	tdchufftbl=fun_huff_dctable(jhuffdcdata);%读出dc的huffman表
	jhuffacdata=fun_read_dht(locff,jpgData,fidorg,2);
	tachufftbl=fun_huff_actable(jhuffacdata);
else
    [jhuffdcdata,jhuffacdata] = fun_read_huff(locff,locc4,jpgData,fidorg);
	tdchufftbl=fun_huff_dctable(jhuffdcdata);   %读出dc的huffman表--第一列码长，后面跟着的是码字的比特
	tachufftbl=fun_huff_actable(jhuffacdata);   %run - category - length - base code length -  base code
end
%% 提取文件比特流
fprintf('提取文件比特流...\n');
jsosdata=fun_read_sos(locff,jpgData,fidorg);%获取SOS扫描部分有效的图片数据压缩段
jsosdataclr=fun_dlt_zero(jsosdata);%去除数据压缩段中255后增补的00
vsosbits=fun_gen_bits(jsosdataclr);%把数据压缩段拉成0或1的一行码流
% [ acPosition,vlcUsedNum ] = fun_parse_data( 4096,vsosbits,tdchufftbl,tachufftbl );
init_len = length(vsosbits);%原始码流比特数
[~,~,pblkrow,pblkcol]=fun_jpg_size(jpgData,locff);
pblknum=pblkrow*pblkcol;%计算图片分割的8*8模块数
% 获取每一个block的位置以及appended信息
tmpi=1;  tmppydcp=1; 
%tmppydcp 每一块DC比特的起始位置
%tmppyacp 每一块AC比特的起始位置
while tmpi<=pblknum
    %vdcapplen：每段中DC appended bitsteam 长度
    [tmppyacp,vdcapplen(tmpi,1)]=fun_parse_dc(vsosbits,tdchufftbl,tmppydcp); 
    dc_posi(tmpi) = tmppydcp;%获取每一个DC地址，即每一个block的位置
    %vaccodeidx{tmpi,1}：第tmpi块中所有AC系数编码的码字在码表中是第几行
    [tmppydcp,vaccodeidx{tmpi,1}]=fun_parse_ac(vsosbits,tachufftbl,tmppyacp);
    tmpi=tmpi+1;
end
%% 解析文件比特流
fprintf('解析文件比特流...\n');
%vlc_used_num - 每种vlc在压缩段中出现的次数（频率）
vlc_used_num = zeros(162,1);
%vlc_group - 将vlc_used_num按照vlc长度分组
vlc_group=cell(1,16);
%vlc_subsets - 每组vlc分成used_VLC和unused_VLC
vlc_subsets = cell(1,16);
for i=1:pblknum
    for j=1:length(vaccodeidx{i,1})
        vlc_used_num(vaccodeidx{i,1}(j,1),1)=vlc_used_num(vaccodeidx{i,1}(j,1),1)+1;
    end
end
for i=1:16
vlc_group{:,i} = (reshape(vlc_used_num(find(tachufftbl(:,4)==i)),1,[]));
unused_num = length(find(vlc_group{:,i}==0));
used_num = length(vlc_group{:,i}) - unused_num;
vlc_subsets{:,i} = [used_num,unused_num];
end
%% 数据分析
payload = max(vlc_used_num); % 最大嵌入载荷
achufftable = sortrows(tachufftbl,4);
ac_vlc(:,1:2) = achufftable(:,1:2);
ac_vlc(:,4) = achufftable(:,4);
flag = 1;
for i=1:16
    if(~isempty(vlc_group{1,i}))
        [rows,columns] = size(vlc_group{1,i});
        for j=1:columns
            ac_vlc(flag,3) = vlc_group{1,i}(1,j);
            flag = flag + 1;
        end
    end
end
acvlc = ac_vlc;
zero_point = find(acvlc(:,3)==0,1);
acvlc(1:zero_point,:) = sortrows(acvlc(1:zero_point,:),-3);
acvlc(:,5) = achufftable(:,4);
increased_proposed = 0; % JPEG图像使用本方法增加的比特数
increased_liu = 0; % JPEG图像使用刘的方法增加的比特数
for i = 2:zero_point
    increased_proposed = increased_proposed + acvlc(i,3) * (acvlc(i+1,5) - acvlc(i,4));
end
liu_vlc = vlc_used_num;
liu_vlc(:,2) = tachufftbl(:,4);
zero_point_liu = find(liu_vlc(:,1)==0,1);
for i = find(max(liu_vlc(:,1)))+1:zero_point_liu
    increased_liu = increased_liu + liu_vlc(i,1) * (liu_vlc(i+1,2) - liu_vlc(i,2));
end