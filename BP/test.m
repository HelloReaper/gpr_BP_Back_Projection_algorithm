x = -pi:pi; y = sin(x); 
new_x = -pi:0.1:pi;
p = pchip(x,y,new_x);
figure(1); % 在同一个脚本文件里面，要想画多个图，需要给每个图编号，否则只会显示最后一个图哦~
plot(x, y, 'o', new_x, p, 'r-')
legend('样本点','三次埃尔米特插值','Location','SouthEast') 