function [stegoBlockdct]=LSB_en(stegoBlockdct,side)
for i=1:81
    stegoBlockdct{i}(1)=stegoBlockdct{i}(1)-mod(stegoBlockdct{i}(1),2)+side(i);
end
end