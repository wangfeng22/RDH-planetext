function [side]=Getside(t)
standby=[4,8,64,256];
pos=find(standby==t)-1;
side = num2bin(quantizer([3 0]),pos);
side = side(2:3);
side=strcat(char(side)','');
side=str2num(side(:));
end