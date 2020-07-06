clear
clc 
%% 高维直方图与框架Algorithm I关于Lena图像的PSNR值比较
% 高维直方图
x0=[0.1,0.15,0.2,0.25];
psnr0=[52.8124,51.1462,49.7948,48.8913];
% Algorithm I
x1=[0.1,0.15,0.2,0.25,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99];
psnr1=[53.0271,51.0667,49.7904,48.8386,46.3430,44.2975,42.5326,41.1828,39.5940,38.0384,36.3270,33.8573];
% Algorithm II
x2=[0.1,0.15];
psnr2=[54.3123,51.2952];
figure;
plot(x0(1,:),psnr0(1,:),'k-x'); %黑色
hold on;
plot(x1(1,:),psnr1(1,:),'r-o'); %红色
hold on;
plot(x2(1,:),psnr2(1,:),'b-*'); %蓝色
% legend('高维直方图','Algorithm I','Algorithm II');
title('Lena图像的PSNR值比较');
xlabel('数据嵌入量（单位：bpp）','LineWidth',14);
ylabel('PSNR(dB)','LineWidth',14);
%% 高维直方图与框架Algorithm I关于Baboon图像的PSNR值比较
% 高维直方图
x0=[0.05,0.09];
psnr0=[50.0936,48.3434,];
% Algorithm I
x1=[0.05,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.98];
psnr1=[49.9764,45.6923,45.3412,39.8941,36.4732,33.7725,31.7557,29.7662,27.6552,25.8236,24.0965,23.0974];
% Algorithm II
x2=[0.05];
psnr2=[51.7156];
figure;
plot(x0(1,:),psnr0(1,:),'k-x'); %黑色
hold on;
plot(x1(1,:),psnr1(1,:),'r-o'); %红色
hold on;
plot(x2(1,:),psnr2(1,:),'b-*'); %蓝色
% legend('高维直方图','Algorithm I','Algorithm II');
title('Baboon图像的PSNR值比较');
xlabel('数据嵌入量（单位：bpp）','LineWidth',14);
ylabel('PSNR(dB)','LineWidth',14);