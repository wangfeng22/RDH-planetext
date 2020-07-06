function [c] = C(I1)
%将像素块中的像素从大到小排序，c为第二大的像素与第二小的像素的差值
I2=I1(:)';
I2=sort(I2,'descend');
c=I2(2)-I2(8);
end

