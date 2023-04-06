function [t_Ak] = Caculate_Time(f,xrs,xA,zA,h)
%CACULATE_TIME 此处显示有关此函数的摘要
%   f : 求解函数
%   xrs: GPR收发天线坐标
%   xA: 成像点横坐标
%   zA: 成像点纵坐标
    c=3e8;
    Epsilon_r=10.0;
    v=c/sqrt(Epsilon_r);
    p = xrs;
    if(xA == xrs)
        p = xA;
    else
        flag = (xA - xrs)/abs(xA - xrs);
        % 设置求解区间(left,right)
        left = min(xrs,xA);
        right = max(xrs,xA);
        [p,count] = binarySearch(f,left,right,flag);
%         fprintf("方程解为: %f \n",p);
%                 re = subs(fr,x,p);
%                 fprintf("带入P进行函数验算结果: %f\n",re);
%                 fprintf("二分查找次数为: %d\n",count);
    end
% 由于信号激发点和回波信号接收点并不在同一个点，故激发点到成像点，成像点到接收点的时延应该分别计算
% 根据那个什么定理，成像点到收发天线的计算方法应该是一样的
    t_Ak = sqrt((p-xrs)^2+h^2)/c + sqrt((xA-p)^2+zA^2)/v;
    
end

