# gprMax波场模拟方法

参考文献：https://codeantenna.com/a/gFkCLW219d



- [前言](https://codeantenna.com/a/gFkCLW219d#_7)
- [1、编写相应的.in文件](https://codeantenna.com/a/gFkCLW219d#1in_16)
- [2、用paraview展示.vti文件](https://codeantenna.com/a/gFkCLW219d#2paraviewvti_23)
- [3、将快照导出为视频或者GIF动画](https://codeantenna.com/a/gFkCLW219d#3GIF_35)

## 前言

    gprMax3.0具有波场快照功能,我们可以通过paraview将正演模拟时电磁波的传播过程给展示出来，让我们先来看一下展示效果。

![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602133637502.gif)

以下是具体的方法步骤，供大家交流学习。

# 1、编写相应的.in文件

在.in文件中加入如下指令：（最后有完整的示例 in 文件）
 ![Alt](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602115202903.png)
 代码的解释上面有标注，左下角坐标和右上角坐标能够将快照的计算区域确定下来；计算间隔就是dx,dy,dz, 越小越费时，但模拟的精细程度越好。计算间隔最好**取网格大小**。



# 2、用paraview展示.vti文件

将编写好的.in文件通过gprMax执行，会生成一系列的.vti文件，如何利用gprMax执行in文件可以参考我之前写的[博客](https://blog.csdn.net/weixin_43682976/article/details/107045085).
 ![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602135130607.png)
 接下来就是用paraview来打开这些vti文件。
 1打开concrete几何模型文件 -> 2点击Apply -3点击gprMax_info
 ![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602135816246.png)
 打开一系列快照文件（snapshot.vti*）
 ![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602140149636.png)
 1选择snapshot*并点亮旁边的小眼睛 -> 2点击Apply -> 3选择E-field -> 4选择magnitud或者z -> 5选择slice
 ![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602140322251.png)
 1、2调节背景介质concrete的透明度以及目标pec的亮度，然后3点击播放即可。最后可以通过4调节播放的速度。
 ![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602141223317.png)

# 3、将快照导出为视频或者GIF动画

File ->save Animation 如果想导出视频，可以选择AVI格式导出，如果想制作GIF动画，需要先将快照导出为png图片存在特定文件夹,再通过一段Python代码来生成GIF动画。
 ![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602141559166.png)
 ![在这里插入图片描述](https://blog-image-beds.oss-cn-beijing.aliyuncs.com/images/20210602141621415.png)
 将指定文件夹中png图片合成为GIF动画的Python代码如下：（此处参考了[博客](https://blog.csdn.net/Neverlevsun/article/details/116107931))

```python
import cv2
import imageio
import os

path = r"F:\learn_gprmax3.0\wave_gif_show\pictures2" # 文件路径
filelists = os.listdir(path)

buff = []
cv2.waitKey(0)
for filelist in filelists:
    file_rode = os.path.join(path, filelist)
    img = cv2.imread(file_rode)
    cv2.imshow('img11', img)
    buff.append(img)
    cv2.waitKey(50)
imageio.mimsave('two_object2.gif',buff,'GIF',duration=0.1)
if cv2.waitKey(0)==ord('q'):
    cv2.destroyAllWindows()
12345678910111213141516171819
```

**最后附上完整的.in 文件**，大家感兴趣的话，赶紧去试试吧！

```html
#title: B-scan from two metal cylinder in concrete
#domain: 0.600 0.200 0.002
#dx_dy_dz: 0.002 0.002 0.002
#time_window: 5e-9

#material: 6 0.1 1 0 concrete

#waveform: ricker 1 1.5e9 my_ricker
#hertzian_dipole: z 0.320 0.162 0 my_ricker
#rx:  0.322 0.162 0
#src_steps: 0.005 0 0
#rx_steps: 0.005 0 0

#box: 0 0 0 0.600 0.160 0.002 concrete
#cylinder: 0.20 0.05 0 0.20 0.05 0.002 0.009 pec
#cylinder: 0.40 0.05 0 0.40 0.05 0.002 0.009 pec
#box: 0 0.160 0 0.600 0.200 0.002 free_space

#geometry_view: 0 0 0 0.600 0.200 0.002 0.002 0.002 0.002 concrete n

#python:
from gprMax.input_cmd_funcs import *
for i in range(1, 50):
  snapshot(0.0, 0.0, 0.0, 0.6, 0.16, 0.002, 0.002, 0.002, 0.002, (i/10)*1e-9, 'snapshot' + str(i))
#end_python:
1234567891011121314151617181920212223242526
```

版权声明：本文为CSDN博主「weixin_43682976」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
 原文链接：https://blog.csdn.net/weixin_43682976/article/details/117464292
