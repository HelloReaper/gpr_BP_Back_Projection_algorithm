"""
python运行gprmax
读取.in文件
运行api函数模拟
"""

import os
import numpy as np
import matplotlib.pyplot as plt
from gprMax.gprMax import api
from tools.outputfiles_merge import get_output_data, merge_files

# 文件路径+文件名
dmax = r"D:\Learnfile\gprmaxSTU\guanxian3D"  # 项目目录
# filename = os.path.join(dmax, 'guanxian_granite_Bscan_2D.txt')

# # 正演  n：仿真次数（A扫描次数）->B扫描
# api(filename, n=98, geometry_only=False )  # geometry_only：仅几何图形
merge_files(dmax+'/'+'PVC03', removefiles=True)
7
# # # 获取回波数据
# # # A B扫描时out文件名不一样
filename = os.path.join(dmax+'/'+'PVC03'+'_merged.out')
rxnumber = 1
rxcomponent = 'Ez'
outputdata, dt = get_output_data(filename, rxnumber, rxcomponent)

# # # 保存回波数据
np.savetxt('shangxiang.txt', outputdata, delimiter=' ')

# # 提取振幅
# def get_ez_value(data):
#     data = abs(data)
#     get_Evalue = data.sum(axis = 0)
#     return get_Evalue

# # print(get_ez_value(outputdata))
# plt.plot(np.arange(1, outputdata.shape[1]+1, 1), get_ez_value(outputdata))
# plt.show()

# # 提取走时
# def get_firsttime_value(data):
#     [a, b] = np.shape(data)
#     door=np.zeros(b)  
#     trvp = []
#     for i in range(b):
#         door[i] = np.max(abs(data))*0.02
#         for j in range(a):
#             if abs(data[j][i]) > door[i]:
#                 trvp = np.append(trvp, data[j][i])
#                 break
#     return trvp

# a = get_firsttime_value(outputdata)
# print(a.shape)
# plt.plot(np.arange(1, outputdata.shape[1]+1, 1), get_firsttime_value(outputdata))
# plt.show()

## B扫描绘图
# from tools.plot_Bscan import mpl_plot
# plt = mpl_plot(filename, outputdata, dt*1e9, rxnumber, rxcomponent)
# plt.ylabel('Time [ns]')
# plt.show()

# # # # A扫描绘图
# # # from tools.plot_Ascan import mpl_plot
# # # from gprMax.receivers import Rx
# # # outputs = Rx.defaultoutputs
# # # outputs = ['Ez']
# # # print(outputs)
# # # plt = mpl_plot(filename, outputs)
# # # plt.show()
# # # # #
# # # #
# # # # A扫描图
# # # outputdata[1:200,]=0    ## 通过置零消除天线耦合波
# # # output = outputdata[:,0]  # 第i道A扫信号：序号从0开始
# # # plt.plot(output)
# # # plt.show()
# # # #
# # # #
# 堆叠波形
# space_signal = float(0.01)   # 信号间隔(按实际情况变更)
# tw = 10              # 时间窗（与in文件一致）
# trace_number = len(outputdata[0])
# for i in range(trace_number):
#     plt.plot(outputdata[:,i]+(i+1)*space_signal,np.linspace(0,tw,len(outputdata)),color='m')
# # plt.xticks(range(space_signal,trace_number*space_signal+1,space_signal),range(1,trace_number+1))
# plt.xlim(0, space_signal*(trace_number+2))
# plt.ylim(0, tw)
# # plt.xlabel('trace_number')
# plt.ylabel('Time [ns]')
# ax = plt.gca()          # 获取句柄
# ax.invert_yaxis()       # y轴反向
# ax.xaxis.tick_top()     # x轴放在上方
# plt.show() 
