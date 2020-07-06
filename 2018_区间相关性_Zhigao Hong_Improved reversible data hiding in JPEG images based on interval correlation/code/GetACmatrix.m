function [AC_matrix,zigzag_blockAC]=GetACmatrix(ori_blockdct)
AC_matrix = zeros(63,4096);
[zigzag_blockAC]=GetZigzag(ori_blockdct);
for i=1:4096
    for j=1:63
        AC_matrix(j,i)=zigzag_blockAC{1,i}(j+1);
    end
end
end