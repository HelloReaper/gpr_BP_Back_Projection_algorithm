clc,clear,close all
Epsilon_r=10.0;
xr=0;
xk=0;
xA=5;
zA=5;
h=0.0025;
error=1e-6;
c=3e9;
v=c/sqrt(Epsilon_r);
% fx=(xr-xk)^2*((xA-xr)^2+zA^2)/(((xr-xk)^2+h^2)*(xA-xr)^2) - Epsilon_r;

syms x;
% f=input("请输入需求零解的方程f(x)=(自变量为x,如x^3-x^2-5):   ");
f=(x-xk)^2*((xA-x)^2+zA^2)/(((x-xk)^2+h^2)*(xA-x)^2) - Epsilon_r;
% p0=input("请输入牛顿迭代法的初始值p_0：  ");
p0=xk+0.5;
% tol=input("请输入精度E：  ");
tol=1e-6;
% maxK=input("请输入最大迭代次数：  ");
maxK=1e4;

[p,k,Y]=newton(f,p0,tol,maxK);
if p>xA
    disp("请重新确定初始值，迭代结果超过了xA!");
end
% DP=sprintf("使用牛顿迭代法法迭代%d次，计算%s=0以%g为迭代初始值的解为：%g",k,f,p0,p);
% disp(DP);
fprintf("迭代值如下：");
% disp(Y);
disp(p);

% 由于信号激发点和回波信号接收点并不在同一个点，故激发点到成像点，成像点到接收点的时延应该分别计算
t_Ak=2*sqrt((p-xk)^2+h^2)/c+2*sqrt((xA-p)^2+zA^2)/v;%乘以2是假设收发点是同一个点

fprintf("点A对应的双程时延为：");
disp(t_Ak);
