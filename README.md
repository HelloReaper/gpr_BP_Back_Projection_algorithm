# README

本程序中包含了前期调试测试用的代码与最终GPR后向投影成像算法的代码。

GPR后向投影成像实现过程：

## 1.环境配置
    * Ubuntu环境下，配置python与gprMax，环境配置可查看官网与百度。
    * 安装linux版本的matlab。

## 2.使用python脚本编写波形数据仿真脚本，配置random_cylinder.in文件
```python
    $ python generate.py
```

生成的B-scan数据在/cylinder_data/目录下的*_merge.out文件中。

## 3. 可以使用python脚本读取gprMax生成的merge.out文件，但是我还没做到这一步，被老板叫停了（为啥叫停，他不想让我继续做这种传统思路的成像算法，但是又不让我研究基于深度学习的成像算法）
打开Matlab：
```matlab
    在BP/目录下运行my_BP4.m读取merge.out文件，并将均值滤波后的Bscan数据写入到txt文件中。
```

## 4. 计算双程时延，由于计算双程时延的时间长，所以计算一次保存在文件中，后面直接读文件就可以了。

进入到/BP/CaculateDoubleTimes/目录下
在终端运行`` python CaculateDoubleTimes.py 0或1``，0是不计算双程时延，1是计算双程时延。并将成像区域对应道数据的叠加幅值计算后写入到amplitudes_adds.txt中


## 5. 在matlab中，在BP/目录下运行my_BP5.m文件，画出BP成像图