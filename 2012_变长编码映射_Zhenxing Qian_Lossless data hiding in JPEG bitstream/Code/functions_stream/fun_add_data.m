function s4 = fun_add_data(s, s1, index)
s2 = s(1:index-1);
index
length(s)
s3 = s(index:length(s));
s4 = [s2;s1;s3];
end
