clear
clc 
%% Algorithm I和Algorithm II与最优转移矩阵关于Lena图像的PSNR值比较
% Algorithm I
x1=[0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99];
psnr1=[53.0271,51.0667,49.7904,46.3430,44.2975,42.5326,41.1828,39.5940,38.0384,36.3270,33.8573];
% Algorithm II
x2=[0.1,0.15];
psnr2=[54.3123,51.2952];
% X.Zhang 最优值转移矩阵
x3=[0.1,0.15,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99,1.0,1.1,1.16];
psnr3=[54.6299,52.7347,51.3319,48.5164,45.7604,43.4408,41.3348,39.6188,37.8837,36.1355,34.6007,34.3868,32.5167,30.5822];
figure;
plot(x1(1,:),psnr1(1,:),'r-o'); %红色
hold on;
plot(x2(1,:),psnr2(1,:),'b-*'); %蓝色
hold on;
plot(x3(1,:),psnr3(1,:),'k-x'); %黑色
legend('Algorithm I','Algorithm II','X.Zhang');
title('Lena图像的PSNR值比较');
xlabel('数据嵌入量（单位：bpp）','LineWidth',14);
ylabel('PSNR(dB)','LineWidth',14);
%% Algorithm I和Algorithm II与最优转移矩阵关于Baboon图像的PSNR值比较
% Algorithm I
x1=[0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.98];
psnr1=[49.9764,45.3412,39.8941,36.4732,33.7725,31.7557,29.7662,27.6552,25.8236,24.0965,23.0974];
% Algorithm II
x2=[0.05];
psnr2=[51.7156];
% X.Zhang 最优值转移矩阵
x3=[0.05,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8];
psnr3=[51.7144,48.2453,42.2706,38.1487,35.0951,32.4974,30.2962,28.1698,25.8477];
figure;
plot(x1(1,:),psnr1(1,:),'r-o'); %红色
hold on;
plot(x2(1,:),psnr2(1,:),'b-*'); %蓝色
hold on;
plot(x3(1,:),psnr3(1,:),'k-x'); %黑色
legend('Algorithm I','Algorithm II','X.Zhang');
title('Baboon图像的PSNR值比较');
xlabel('数据嵌入量（单位：bpp）','LineWidth',14);
ylabel('PSNR(dB)','LineWidth',14);