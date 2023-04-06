clc;
clear;
format short;

Epsilon_r=10.0;
% xr=0.3:0.01:0.8;%信号接收点x坐标
% xs=0.2:0.01:0.7;%信号发射点x坐标
% xA=0.0025:0.0025:1;%成像点x坐标
% zA=0.0025:0.0025:1;%成像点z坐标
h=0.0025;
error=1e-6;
c=3e9;
Epsilon_r=10.0;
v=c/sqrt(Epsilon_r);

xr_low = 0.3;
xr_high = 0.8;
% 收发天线移动步长
rs_step = 0.1;
% 网格大小
dx = 0.05;
xA_low = 0.1;
xA_high = 1;
zA_low = 0.1;
zA_high = 1;

% 三维矩阵计算成像区域到不同天线收发点的双程时延
% 将成像区域网格化，然后分别计算每个网格中心的双程时延
row = (xA_high-xA_low)/dx + 1;
col = (zA_high-zA_low)/dx + 1;
% page等于收发天线的位置个数
page = (xr_high-xr_low)/rs_step + 1;
DoubleTimes = zeros(row,col,page);

% 收发天线间隔
rs_interval=0.1;

page = 1;
% xr和xs为收发天线的坐标，设置二者间隔后可只用一个循环
for xr=xr_low:rs_step:xr_high
    xs = xr - rs_interval;
    row = 1;
    for xA=xA_low:dx:xA_high
        col = 1;
        for zA=zA_low:dx:zA_high
        % 计算成像点到接收天线的时延
            syms x;
            fr=(x-xr)^2*((xA-x)^2+zA^2)/(((x-xr)^2+h^2)*(xA-x)^2) - Epsilon_r;
            fs=(x-xs)^2*((xA-x)^2+zA^2)/(((x-xs)^2+h^2)*(xA-x)^2) - Epsilon_r;
            [t_Ak_r] = Caculate_Time(fr,xr,xA,zA,h);
            [t_Ak_s] = Caculate_Time(fs,xs,xA,zA,h);
            t_Ak = t_Ak_r + t_Ak_s;
            
%             fprintf("xr = %f ,xA = %f, zA = %f, 点A对应的双程时延为：%12.5e\n",xr,xA,zA,t_Ak);
            DoubleTimes(row,col,page) = t_Ak;
            col = col + 1;
        end
        row = row + 1;
    end
    page = page + 1;
end






