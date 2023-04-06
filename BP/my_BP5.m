clear all, clc;
data = load('./Data/amplitudes_adds.txt');
% data中一行是一列纵向深度成像区域对应的幅值叠加和
% 所以后面需要进行转置
data = data';
xA = 0.02:0.002:1-0.02;
zA = 0.002:0.002:1;
figure;
% imagesc('XData',xA,'YData',zA,'CData',data);
imagesc(data);
colorbar;