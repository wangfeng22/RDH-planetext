function [ acPosition,vlcUsedNum ] = fun_parse_data( blockNum,jpgData,dcTable,acTable )
acPosition=cell(blockNum,1);
vlcUsedNum=zeros(162,1);
data_ptr=1;%表示当前扫描到data中的位置
for i=1:blockNum
    disp(i);
    acPtr=1;
    for j=1:12
       len=size(jpgData(1,data_ptr:size(jpgData,2)),2);
       if(dcTable(j,1)>len)
            continue;
       end
       if(isequal(jpgData(1,data_ptr:(data_ptr+dcTable(j,1)-1)),dcTable(j,2:(dcTable(j,1)+1))))
        	data_ptr=data_ptr+dcTable(j,1);
            break;
       end
    end
    data_ptr=data_ptr+j-1;
    ac_num=0;
    while ((~isequal(jpgData(1,data_ptr:data_ptr+3),[1 0 1 0]))&&(ac_num~=63))
        for j=1:162%若压缩数据段指针匹配到第i行ac码表时，进行后续操作
            len = length(jpgData(1,:))-data_ptr;
            if len>acTable(j,4)-1
                if(isequal(jpgData(1,data_ptr:(data_ptr+acTable(j,4)-1)),acTable(j,5:acTable(j,4)+4))) 
                    break;
            	end  
            end
            
        end
        acPosition{i,1}(acPtr,2)=data_ptr+acTable(j,4);
        acPosition{i,1}(acPtr,1)=j;
        vlcUsedNum(j,1)=vlcUsedNum(j,1)+1;
        acPtr=acPtr+1;
        data_ptr=data_ptr+acTable(j,3);
        if(j==152)
        	ac_num=16+ac_num;
        else
            ac_num=acTable(j,1)+1+ac_num;
        end  
    end
    if(isequal(jpgData(1,data_ptr:(data_ptr+3)),[1 0 1 0]))
        data_ptr=data_ptr+4;
        acPosition{i,1}(acPtr,2)=data_ptr+acTable(1,4);
        acPosition{i,1}(acPtr,1)=1;
        vlcUsedNum(1,1)=vlcUsedNum(1,1)+1;
    end   
end
end

