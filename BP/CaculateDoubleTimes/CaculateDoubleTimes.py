import os
import math
import numpy as np
from scipy.interpolate import interp1d,UnivariateSpline,Rbf
import pylab as pl

def binarySearch(low,high,flag,xrs,xA,zA,h,Epsilon_r):
#   BINARYSEARCH 使用二分法求解一元四次方程
#   此处显示详细说明
#   f是一元四次方程
#   low查找区间下限
#   high查找区间上限，均为开区间
#   flag=1,该函数单调递增，flag=-1,该函数单调递减
    if high == low:
        p = high
        count = 0
        return p
    if flag != 1 and flag != -1:
        print("flag输入错误,flag=1,该函数单调递增,flag=-1,该函数单调递减")
        return p
#   数据精度
    error = 1e-8
    Max_Count = 1e5
    count = 0
    step = 1e-8
    mid = -1

    rs = xrs
    A = xA
    Z = zA
    Ep = Epsilon_r
    H = h

    frs='pow((x-rs),2)*(pow(A-x,2)+pow(Z,2))/((pow(x-rs,2)+pow(H,2))*pow(A-x,2)) - Ep'
    while low <= high and count < Max_Count:
        mid=low + (high-low) / 2
        x = mid
        fmid = eval(frs)

        if flag * fmid > 0:
            high = mid - step
        elif flag * fmid < 0:
            low = mid + step
        elif abs(fmid - 0) < error:
            p = mid
            return
        count = count + 1
    p = mid
    return p



def Caculate_Time(xrs,xA,zA,h):
#CACULATE_TIME 此处显示有关此函数的摘要
#   f : 求解函数
#   xrs: GPR收发天线坐标
#   xA: 成像点横坐标
#   zA: 成像点纵坐标
    c=3e9
    Epsilon_r=10.0
    v=c/np.sqrt(Epsilon_r)
    p = xrs
    if xA == xrs:
        p = xA
    else:
        flag = (xA - xrs)/abs(xA - xrs)
        # 设置求解区间(left,right)
        left = min(xrs,xA)
        right = max(xrs,xA)
        p = binarySearch(left,right,flag,xrs,xA,zA,h,Epsilon_r)
# 由于信号激发点和回波信号接收点并不在同一个点，故激发点到成像点，成像点到接收点的时延应该分别计算
# 根据那个什么定理，成像点到收发天线的计算方法应该是一样的
    t_Ak = 0
    t_Ak = math.sqrt(pow(p-xrs,2)+pow(h,2))/c + math.sqrt(pow(xA-p,2)+pow(zA,2))/v
    return t_Ak


if __name__== "__main__" :
    Epsilon_r=10.0 
    # xr=0.3:0.01:0.8 #信号接收点x坐标
    # xs=0.2:0.01:0.7 #信号发射点x坐标
    # xA=0.0025:0.0025:1 #成像点x坐标
    # zA=0.0025:0.0025:1 #成像点z坐标
    h=0.0025 
    error=1e-6 
    c=3e9 
    Epsilon_r=10.0 
    v=c/math.sqrt(Epsilon_r) 

    xr_low = 0.3 
    xr_high = 0.8
    # 收发天线移动步长
    rs_step = 0.01
    # 网格大小
    dx = 0.0025
    xA_low = 0.1 
    xA_high = 1 
    zA_low = 0.1 
    zA_high = 1 
    # 收发天线间隔
    rs_interval=0.1 

    xs_low = xr_low - rs_interval
    xs_high = xr_high - rs_interval

    xr=np.arange(xr_low,xr_high + rs_step,rs_step) #信号接收点x坐标
    xs=np.arange(xs_low,xs_high ,rs_step) #信号发射点x坐标
    xA=np.arange(xA_low,xA_high ,dx) #成像点x坐标
    zA=np.arange(zA_low,zA_high ,dx) #成像点z坐标

    print(xr)

    # 三维矩阵计算成像区域到不同天线收发点的双程时延
    # 将成像区域网格化，然后分别计算每个网格中心的双程时延
    row = len(xA)
    col = len(zA)
    # page等于收发天线的位置个数
    page = len(xr)

    print("row = %d ,col = %d ,page = %d \n"%(row,col,page))

    # size = (page,row,col)
    # DoubleTimes = np.zeros(size,dtype=np.float64)

    # 将收发天线每个位置对应的成像区域对应的双程时延保存到不同的文件中
    # for page in range(len(xr)):
    #     filepath = '../Data/DoubleTimes_%d.txt'%(page)
    #     file = open(filepath,'w+')
    #     for row in range(len(xA)):
    #         for col in range(len(zA)):
    #         # 计算成像点到接收天线的时延
    #             t_Ak_r = Caculate_Time(xr[page],xA[row],zA[col],h) 
    #             t_Ak_s = Caculate_Time(xs[page],xA[row],zA[col],h) 
    #             t_Ak = t_Ak_r + t_Ak_s 
    #             # 文件中每一行数据，是成像区域中纵向一列的双程时延
    #             file.write(str(t_Ak)+'\t')
    #             # DoubleTimes[page][row][col] = t_Ak
    #         file.write('\n')
    #     file.close()


    # 读取B-scan回波数据文件
    field = []
    fid = open('../Data/flter_field.txt','r')
    for line in fid:
        data_line = line.strip("\n").split()
        field.append([float(i) for i in data_line])
    fid.close()
    

    times = []
    time_fid = open('../Data/times.txt','r')
    for line in time_fid:
        times.append(float(line))
    time_fid.close()

    double_time = []
    dt_file = open('../Data/DoubleTimes_0.txt','r')
    for dt in dt_file:
        dtime = dt.strip("\n").split()
        double_time.append([float(i) for i in dtime])
    dt_file.close()

    field = np.array(field)
    times = np.array(times)
    double_time = np.array(double_time)

    pl.plot(times,field[:,0],'o')

    interp_func = interp1d(times, field[:,0])
    newarr = interp_func(double_time[0,:])
    pl.plot(double_time[0,:],newarr)

    pl.show()
