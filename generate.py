import os
import shutil
import pycuda
import pycuda.driver as drv
from gprMax.gprMax import api
from tools.outputfiles_merge import get_output_data, merge_files
import matplotlib.pyplot as plt
import numpy as np
from tools.plot_Bscan import mpl_plot
import threading
from multiprocessing import Process



def Generate_Data(num):
    drv.init()
    origin_file = '/random_cylinder.in'
    num_of_Bscan=10
    num_scan=51  # 一个B-Scan中有51道数据
    num_sample_points=10

    for i in range(num):
        file_path=r"./cylinder_data"
        if(os.path.exists(file_path)):
            print(f'文件夹{file_path}已存在\n')
        else:
            os.mkdir(file_path)
            print(f'文件夹{file_path}创建成功!\n')

        f1 = open("./random_cylinder.in", 'r+', encoding='utf-8')     # 打开本地的配置文本文件
        content = f1.read()     # 读取text文本文件中的内容
        f1.close()              # 关闭操作

        # new_hertzian_dipole_content = "#hertzian_dipole: z {} 1.0025 0 my_ricker".format(0.1+0.005)
        # old_hertzian_dipole_content = "#hertzian_dipole: z 0.2 1.0025 0 my_ricker"
        # new_rx_content="#rx: {} 1.0025 0".format(0.2+0.005)
        # old_rx_content="#rx: 0.3 1.0025 0"
        # if old_hertzian_dipole_content not in content:
        #     print("文件 {} old_hertzian_dipole_content not exit!\n".format(i))
        # else:
        #     content=content.replace(old_hertzian_dipole_content, new_hertzian_dipole_content)  # 内容替换
        #     print(new_hertzian_dipole_content)
        # if old_rx_content not in content:
        #     print("文件 {} old_rx_content not exit!\n".format(i))
        # else:
        #     content=content.replace(old_rx_content, new_rx_content)  # 内容替换
        #     print(new_rx_content)
        
        with open("{}/random_cylinder.in".format(file_path), "w", encoding='utf-8') as f2:   # 再次打开test.txt文本文件
            f2.write(content)      # 将替换后的内容写入到test.txt文本文件中
            print("文件 {} 生成成功!\n".format(file_path+origin_file))
            f2.close()
        
        api(file_path+origin_file, n=num_scan, geometry_only=False, gpu={0})
        merge_files(file_path+"/random_cylinder", removefiles=True)

        rxnumber = 1
        rxcomponent = 'Ez'
        file_path_out = file_path+"/random_cylinder"+"_merged.out"
        outputdata, dt = get_output_data(file_path_out, rxnumber, rxcomponent)

        plt.imshow(outputdata, extent=[0, outputdata.shape[1], outputdata.shape[0] * dt, 0], interpolation='nearest', aspect='auto', cmap='seismic', vmin=-np.amax(np.abs(outputdata)), vmax=np.amax(np.abs(outputdata)))
        plt.xlabel('Trace number')
        plt.ylabel('Time [s]')
        plt.savefig("cylinder.jpg")
        plt.show()

        # 拷贝一个文件到另一个文件夹
        # matlab_file_path="/home/lk/Codes/Matlab/GPR/more_cylinder"
        # if os.path.isfile(file_path_out):#用于判断某一对象(需提供绝对路径)是否为文件
        #     shutil.copy(file_path_out, matlab_file_path)#shutil.copy函数放入原文件的路径文件全名  然后放入目标文件夹


if __name__ == "__main__":
        Generate_Data(1) # 将这些数据全都放在一个B-SCAN中模拟计算，然后在拆分为多个B-SCAN数据
        