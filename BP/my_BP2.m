clc,clear,close all
Epsilon_r=10.0;
% xr=0.3:0.01:0.8;%信号接收点x坐标
% xs=0.2:0.01:0.7;%信号发射点x坐标
% xA=0.0025:0.0025:1;%成像点x坐标
% zA=0.0025:0.0025:1;%成像点z坐标
h=0.0025;
error=1e-6;
c=3e9;
rs_interval=0.1;
v=c/sqrt(Epsilon_r);

% [p]=solvex(0.5035,h,0.5,0.5,Epsilon_r);

% for xr=0.3:0.01:0.8
%     for xA=0.0025:0.0025:1
xr=0.3;
xA=0.0025;
zA=0.5;

syms x;
fr=(x-xr)^2*((xA-x)^2+zA^2)/(((x-xr)^2+h^2)*(xA-x)^2) - Epsilon_r;
figure;
ezplot(fr,[-0.5,0.5]);
flag = (xA - xr)/abs(xA - xr);

% 设置求解区间(left,right)
left = min(xr,xA);
right = max(xr,xA);
[p,count] = binarySearch(fr,left,right,flag);
fprintf("方程解为: %f \n",p);
re = subs(fr,x,p);
fprintf("带入P进行函数验算结果: %f\n",re);
fprintf("二分查找次数为: %d\n",count);


%         for zA=0.0025:0.0025:1
%             [p]=solvex(xr,h,xA,zA,Epsilon_r);
% % 由于信号激发点和回波信号接收点并不在同一个点，故激发点到成像点，成像点到接收点的时延应该分别计算
%             t_Ak=2*sqrt((p-xk)^2+h^2)/c+2*sqrt((xA-p)^2+zA^2)/v;%乘以2是假设收发点是同一个点
%             disp(t_Ak);
%             fprintf('%f %f %f\n',xr,xA,zA);
%         end 
%     end
% end


% % 由于信号激发点和回波信号接收点并不在同一个点，故激发点到成像点，成像点到接收点的时延应该分别计算
% t_Ak=2*sqrt((p-xk)^2+h^2)/c+2*sqrt((xA-p)^2+zA^2)/v;%乘以2是假设收发点是同一个点
% 
% fprintf("点A对应的双程时延为：");
% disp(t_Ak);
