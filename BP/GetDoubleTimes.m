function [DoubleTimes,row,col,page] = GetDoubleTimes()
%GETDOUBLETIMES 此处显示有关此函数的摘要
%   此处显示详细说明
%     format short;
    Epsilon_r=10.0;

    h=0.0025;
    error=1e-6;
    c=3e8;
    Epsilon_r=10.0;
    v=c/sqrt(Epsilon_r);

    xr_low = 0.3;
    xr_high = 0.5;
    % 收发天线移动步长
    rs_step = 0.1;
    % 网格大小
    dx = 0.1;
    xA_low = 0.1;
    xA_high = 1;
    zA_low = 0.1;
    zA_high = 1;
    % 收发天线间隔
    rs_interval=0.1;
    
    xr=xr_low:rs_step:xr_high;%信号接收点x坐标
    xr_size = size(xr);
    xs=xr - rs_interval;%信号发射点x坐标
    xA=xA_low:dx:xA_high;%成像点x坐标
    xA_size = size(xA);
    zA=zA_low:dx:zA_high;%成像点z坐标
    zA_size = size(zA);
    

    % 三维矩阵计算成像区域到不同天线收发点的双程时延
    % 将成像区域网格化，然后分别计算每个网格中心的双程时延
    row_len = xA_size(2);
    col_len = zA_size(2);
    % page等于收发天线的位置个数
    page_len = xr_size(2);
    DoubleTimes = zeros(row_len,col_len,page_len);

    for page = 1:page_len
        for row = 1:row_len
            for col = 1:col_len
                syms x;
                fr=(x-xr(page))^2*((xA(row)-x)^2+zA(col)^2)/(((x-xr(page)^2)+h^2)*(xA(row)-x))^2 - Epsilon_r;
                fs=(x-xs(page))^2*((xA(row)-x)^2+zA(col)^2)/(((x-xs(page)^2)+h^2)*(xA(row)-x))^2 - Epsilon_r;
%               计算成像点到接收天线的时延
                t_Ak_r = Caculate_Time(fr,xr(page),xA(row),zA(col),h);
                t_Ak_s = Caculate_Time(fs,xs(page),xA(row),zA(col),h);
                t_Ak = t_Ak_r + t_Ak_s;
%                 fprintf("xr = %f ,xA = %f, zA = %f, 点A对应的双程时延为：%12.8e\n",xr(page),xA(row),zA(col),t_Ak);
                DoubleTimes(row,col,page) = t_Ak;
            end
        end
    end
end

