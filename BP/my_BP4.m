clear all, clc;
% 读取B-scan回波信号数据文件
[flter_field,time] = read_mergeout();
% [DoubleTimes,row,col,page] = GetDoubleTimes();

field_size = size(flter_field);
fid = fopen("./Data/flter_field.txt",'wt');
for row = 1 : field_size(1)
    fprintf(fid, '%f\t', flter_field(row,:));
    fprintf(fid, '\n');
end
fclose(fid);

time_fid = fopen("./Data/times.txt",'wt');
time_size = size(time);
for t = 1 : time_size(1)
    fprintf(time_fid, '%.15e\n', time(t,:));
end
fclose(time_fid);