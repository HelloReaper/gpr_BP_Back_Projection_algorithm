function [p,count] = binarySearch(f,low,high,flag)
%BINARYSEARCH 使用二分法求解一元四次方程
%   此处显示详细说明
%   f是一元四次方程
%   low查找区间下限
%   high查找区间上限，均为开区间
%   flag=1,该函数单调递增，flag=-1,该函数单调递减
    if high == low
        p = high;
        count = 0;
        return;
    end
    if flag ~= 1 && flag ~= -1
        disp("flag输入错误，flag=1,该函数单调递增，flag=-1,该函数单调递减");
        return;
    end
%   数据精度
    error = 1e-8;
    Max_Count = 1e5;
    count = 0;
    syms x;
    step = 1e-8;
    mid = -1;
    while low <= high && count < Max_Count
        mid=low + (high-low) / 2;
        fmid = subs(f,x,mid);
        if flag * fmid > 0
            high = mid - step;
        elseif flag * fmid < 0
            low = mid + step;
        elseif abs(fmid - 0) < error
            p = mid;
            return;
        end
        count = count + 1;
    end
    p = mid;
end

