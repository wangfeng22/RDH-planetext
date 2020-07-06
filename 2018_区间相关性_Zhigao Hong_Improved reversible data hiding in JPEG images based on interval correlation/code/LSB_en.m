function [stego_blockdct]=LSB_en(stego_blockdct,side)
for i=1:2
    stego_blockdct{i}(1)=stego_blockdct{i}(1)-mod(stego_blockdct{i}(1),2)+side(i);
end
end