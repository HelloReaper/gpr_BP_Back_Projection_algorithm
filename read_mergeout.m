% plot_Bscan.m
% Script to plot EM fields from a gprMax B-scan
%
% Craig Warren
clear all, clc

[filename, pathname] = uigetfile('*.out', 'Select gprMax output file to plot B-scan', 'MultiSelect', 'on');
filename = fullfile(pathname, filename);

% Open file and read fields
if filename ~= 0
    iterations = double(h5readatt(filename, '/', 'Iterations'));
    dt = h5readatt(filename, '/', 'dt');

    prompt = 'Which field do you want to view? Ex, Ey, or Ez: ';
    field = input(prompt,'s');
    fieldpath = strcat('/rxs/rx1/', field);
    field = h5read(filename, fieldpath)';
    time = linspace(0, (iterations - 1) * dt, iterations)';
    traces = 0:size(field, 2);

    fh1=figure('Name', filename);
    clims = [-max(max(abs(field))) max(max(abs(field)))];
    im = imagesc(traces, time, field, clims);
    xlabel('Trace number');
    ylabel('Time [s]');
    c = colorbar;
    c.Label.String = 'Field strength [V/m]';
    ax = gca;
    ax.FontSize = 16;
    xlim([0 traces(end)]);

    % Options to create a nice looking figure for display and printing
    set(fh1,'Color','white','Menubar','none');
    X = 60;   % Paper size
    Y = 30;   % Paper size
    xMargin = 0; % Left/right margins from page borders
    yMargin = 0;  % Bottom/top margins from page borders
    xSize = X - 2*xMargin;    % Figure size on paper (width & height)
    ySize = Y - 2*yMargin;    % Figure size on paper (width & height)

    % Figure size displayed on screen
    set(fh1, 'Units','centimeters', 'Position', [0 0 xSize ySize])
    movegui(fh1, 'center')

    % Figure size printed on paper
    set(fh1,'PaperUnits', 'centimeters')
    set(fh1,'PaperSize', [X Y])
    set(fh1,'PaperPosition', [xMargin yMargin xSize ySize])
    set(fh1,'PaperOrientation', 'portrait')

end


% 均值法去除直达波
av=mean(field,2);
flter_field=field-av;







% field(1:1000,:)=0;%去掉自直达波，这里是直接清零
% % figure;imagesc(field);
% [max_field,index]=max(field,[],1);%index数组中保存每一道数据最大值对应的行号
% 
% matrix_size=size(field);
% col=matrix_size(2);
% row=matrix_size(1);
% sonwaves=zeros(181,col);
% for i=1:col
%     mid=index(i);
%     sonwaves(:,i)=field(mid-90:mid+90,i);%其实如果只是获取子波对应的时间就是mid-90:mid+90
% end
% 
% 
% % max_index
% % 这里使用所在行号代表深度信息
% % 生成深度最好在0-10范围内
% max_index=max(index)+3;%保留一点间隔所以+3
% min_index=min(index)-3;%同样保留一点间隔
% internal=max_index-min_index;%找到最大最小行号
% 
% % 生成scan.txt保存每一帧的扫描数据
% % 一帧数据取51道数据,中间道视为传感器点
% % 生成的数据包含131道A-SCAN数据，故可以得到80帧数据，两帧数据之间间隔一个步长0.005
% 
% 
% Ascan_num=1000;
% frame_num=col;
% 
% scan_fid=fopen('./more_cylinder/data_4/ranges.txt','wt');
% 
% % 归一化到1-10之间
% nor=10;
% normal_index=(index-min_index)/internal*nor;
% 
% for k=1:frame_num
%     for j=1:Ascan_num-1% 每一行的最后一个数据后接上换行符
%         in = 180/Ascan_num;
%         fprintf(scan_fid,'%1.6f',(index(k)-90+j*in)/1000);
%         fprintf(scan_fid,'%c',',');
%     end
%     fprintf(scan_fid,'%1.6f',(index(k)-90+1000*in)/1000);
%     fprintf(scan_fid,'%c\n','');
% end
% 
% fclose(scan_fid);
% % 至此scan.txt生成完毕
% 
% % 生成pose.txt文件，一帧数据对应一个pose点(x,y,theta) theta是机器人自身相对于世界坐标系的夹角,这里取0
% % 假设GPR设备始终沿同一方向同一条直线前进
% pose_fid=fopen('./more_cylinder/data_4/pose.txt','wt');
% for k=1:frame_num
%     fprintf(pose_fid,'%1.6f,%1.6f,%f\n',0.2+0.005*(k-1),1.0025,0.0);
% end
% fclose(pose_fid);
% 
% 
% % 生成scan_angle.txt, 均分弧度(45-135度)
% angle_fid=fopen('./more_cylinder/data_4/scanAngles.txt','wt');
% % 设置探地雷达的视角为45-135度
% angles=pi/4:pi/2000:3*pi/4;
% for j=1:Ascan_num-1
%     fprintf(angle_fid,'%2.6f,',angles(j));
% end
% fprintf(angle_fid,'%2.6f\n',angles(Ascan_num));
% fclose(angle_fid);
