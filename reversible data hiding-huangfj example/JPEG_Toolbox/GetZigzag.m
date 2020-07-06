%算法：对矩阵进行zigzag编码，输出zigzag序列
function dctVector = GetZigzag(Block)  
Block = Block';
count = 1;
for dim_sum = 2 : (size(Block, 1) + size(Block, 2))
    if mod(dim_sum, 2) == 0
        for i = 1 : size(Block, 1)
            if dim_sum - i <= size(Block, 1) && dim_sum - i > 0
                dctVector(count) = Block(i, dim_sum - i);
                count = count + 1;
            end
        end
    else
        for i = 1 : size(Block, 1)
            if dim_sum - i <= size(Block, 1) && dim_sum - i >0
                dctVector(count) = Block(dim_sum - i, i);
                count = count + 1;
            end
        end
    end
end
end