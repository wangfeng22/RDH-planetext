function [Opt] = Optimal_Shadow(Hist,num_D)  %%（论文参数）
% Lena图像
Opt_cell = cell(1,5);
Opt_cell{1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ; 1 1 2 2 2 3 3 4 4 5 6 -1 -1 -1 -1 -1];
Opt_cell{2} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ; 0 1 1 1 1 1 1 1 1 1 2 2 4 -1 -1 -1];
Opt_cell{3} = [2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 ; 1 2 2 2 3 3 3 3 3 3 3 3 3 4  -1 -1 ];
Opt_cell{4} = [3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 1 ; 2 2 2 2 2 2 2 3 3 3 5 6 -1 -1 -1 -1];
Opt_cell{5} = [3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 1 ; 2 2 2 2 2 3 3 3 3 3 3 5 5 -1 -1 -1];

for i=1:5
    num = 512*512*0.1*i;
    if num_D==floor(num/2) || num_D==floor(num/2)+1
        Opt = Opt_cell{i};
        break;
    end
end
