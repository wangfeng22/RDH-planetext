function [PSNR_value] = psnr( origin,test )
%PSNR Summary of this function goes here
%   Detailed explanation goes here
% I1=double(origin);
% I2=double(test);
E = origin-test;
MSE=mean2(E.*E);                               %计算均方误差
if(MSE==0)
    PSNR_value = -1;
else
    PSNR_value = 10*log10(255*255/MSE);        %psnr公式
end
end

