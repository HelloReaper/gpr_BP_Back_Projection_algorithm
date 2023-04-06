clc
clear all
fs=40e9;
fc=7.5e9;
B=3e9;
N=1024;
M=512;
Z=512;

c=3e08;
deta_d=0.01;
% tc = gauspuls('cutoff',fc,bw,bwr,tpe) 产生一个高斯调制射频波的截止时间tc,
% 在该截止时间tc处，尾随脉冲包络相对于峰包络振幅低于tpe dB。 
% 尾随脉冲包络电平tpe必须小于0，因为它表示小于峰值（单位）包络幅度的参考电平。 tpe的默认值为-60 dB。
tc=gauspuls('cutoff',fc,B/fc,[],-40);
t=-tc:1/fs:tc;
% yi = gauspuls(t,fc,bw)在数组t指定的时间内返回一个单位幅度的高斯射频脉冲，中心频率为fc，单位Hz，分数带宽为bw，但必须大于0。
[yi,yq,ye] = gauspuls(t,fc,B/fc);
figure;
plot(t,yi);
ylabel('h(t)');
xlabel('t');
grid on