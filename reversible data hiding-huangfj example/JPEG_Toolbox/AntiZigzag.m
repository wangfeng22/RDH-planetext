%算法：根据输入的zigzag序列获得原来的矩阵
function  Block= AntiZigzag(dctVector)  
%Block = Block';
Block=cell(64,64);
count = 1;
for dim_sum = 2 : (size(Block, 1) + size(Block, 2))
    if mod(dim_sum, 2) == 0
        for i = 1 : size(Block, 1)
            if dim_sum - i <= size(Block, 1) && dim_sum - i > 0
                Block(i, dim_sum - i) = dctVector(count);
                count = count + 1;
            end
        end
    else
        for i = 1 : size(Block, 1)
            if dim_sum - i <= size(Block, 1) && dim_sum - i >0
                Block(dim_sum - i, i)=dctVector(count);
                count = count + 1;
            end
        end
    end
end
Block=Block';
end