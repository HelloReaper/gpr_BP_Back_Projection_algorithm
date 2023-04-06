function [x] = solvex(xr,h,xA,zA,Epsilon_r)
%SOLVEX use to caculate zheshe point
    if abs(xr-xA)<=0.003
        p=xr;
    else
        flag=(xA-xr)/abs(xA-xr);
        syms x;
        fr=(x-xr)^2*((xA-x)^2+zA^2)/(((x-xr)^2+h^2)*(xA-x)^2) - Epsilon_r;
        p0=xr+flag*abs(xA-xr)/2;% 设置初始迭代值
        tol=1e-5;% error
        maxK=1e6;
        % 牛顿迭代法求解
        [p,k,Y]=newton(fr,p0,tol,maxK);       
    end
    fprintf("迭代值如下：");
    disp(p);
    x=p;
end

