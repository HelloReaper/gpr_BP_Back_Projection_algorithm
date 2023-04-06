%% Name: 星载圆迹全息3DSAR点目标仿真(BP-CS算法)
%  模式：收发共用
%  发射Chirp信号；
%  Date: 2017.7.18 
%  Author：王鹏飞
% 说明： 至少8个雷达才能实现高度向的分辨
%% 参数设置
clc;close all; clear all;
c=3e8;  %光速
%星载SAR
disp('Spaceborne Circle SAR')
%%雷达参数
fc=5.3e9;                                                               %载频 C波段
lamda=c/fc;                                                             %波长 
Br=30e6;                                                                %线性调频信号调频率带宽 30MHz
Tr=40e-6;                                                               %脉冲持续时间
Kr=Br/Tr;                                                               %调频率
Fr=1.2*Br;                                                              %快时间采样率  1.2倍带宽
H=800e3;                                                                %SAR的距离向距离 800km
theta=26.288/180*pi;                                                    %俯仰角θ(下视角)
Yc=H*tan(theta);
R0=H/cos(theta);
rouY = c/(Br*2);                                                        % 距离向分辨率
gama = 0*pi/180;                                                        %方位向斜视角  正侧视 side-looking
D=10;                                                                   %SAR 方位向天线长度
rouX = D/2;                                                             %方位向分辨率
V=7000;                                                                 %SAR速度

Ka=-2*V^2/lamda/R0;                                                    %doppler 调频率
Lsar=0.886*lamda*R0/D;                                                 %SAR 合成孔径长度
Tsar=Lsar/V; 
Ba=abs(Ka*Tsar);                                                        %doppler 调频带宽（方位带宽）
PRF=1.2*Ba;                                                                 %脉冲重复频率

%%目标区域
Xmin=-200;                                                                %目标区的方位向范围[Xmin,Xmax]
Xmax=200; 
%方位时间序列
PRT=1/PRF;                                                              %脉冲重复间隔
ds=PRT;                                                                 %慢时间域采样步长                               
Nslow=2048;                                      %慢时间域采样数
%Nslow=2^nextpow2(Nslow);                                                %写成2的指数 for fft
ta=-PRT*Nslow/2:PRT:PRT*(Nslow/2-1);                     %慢时间域离散时间序列


%距离时间序列
Y0=1000;  %地距向成像范围[Yc-Y0,Yc+Y0]                                                                      
dt=1/Fr;                                                               %快时间域采样步长                                                           %SAR 合成孔径时间
                                            
Rmin=sqrt(H^2+(Yc-Y0)^2);                                                %SAR与一个孔径测绘带的最短距离                                         
Rmax=sqrt(H^2+(Yc+Y0)^2);                                               %SAR与一个孔径测绘带的最长距离
Nfast=ceil(2*(Rmax-Rmin)/c/dt+Tr/dt);                                   %快时间域的采样数
tr=linspace(2*Rmin/c-Tr/2,2*Rmax/c+Tr/2,Nfast);                       %快时间域的离散时间序列
r=tr*c/2;%距离向的距离序列

%%采样分辨率
DR=c*dt/2;                                                              %距离向分辨率
DX=V*ds;                                                                 %方位向分辨率
%% 目标参数   极坐标
% Rpt=[0 20 20 20 20];                                                     %目标点的位置,径向位置
% thetaT=[0,0,0,0,0];                                                        %仰角
% alpha=[0,pi/4,3*pi/4,5*pi/4,7*pi/4];                                       %方位角

Rpt=[R0-5 R0+5 R0-5 R0+5];                                                     %目标点的位置,径向位置
Xpt=[-5 -5 5 5]; 
Spt=[10 20 10 20];



Npt=length(Rpt);                                                           %目标个数
%% 基线参数
sN=9;%9颗卫星
Bx=0;
By=0;%
Bs=0;%高度基线

K=Npt;                                                                   %目标个数
N=Nslow;                                                                %慢时间域向量长度（即采样个数）
M=Nfast;                                                                %快时间域向量长度

Srnm_sN=zeros(N,M,sN);  
for i=1:1:sN
    for k=1:1:K
        sigma=1;
        Dslow=ta*V-Xpt(k);                                                  %SAR与目标方位向距离形成的序列
        R=sqrt(Dslow.^2+(Rpt(k)-By(i))^2+(Bs(i)-Spt(k))^2);                         %生成径向距离序列    加入距离向基线
        tau=2*R/c;                                                          %生成径向距离延迟序列
        Dfast=ones(N,1)*tr-tau'*ones(1,M);                                  %生成t-tao矩阵
        phase=pi*Kr*Dfast.^2-(4*pi/lamda)*(R'*ones(1,M));                  %回波相位矩阵
        Srnm_sN(:,:,i)=Srnm_sN(:,:,i)+sigma*exp(j*phase).*(abs(Dfast)<=Tr/2).*((abs(Dslow)<=Lsar/2)'*ones(1,M));
    end
end


figure;
imagesc(imag(Srnm(:,:,1)));colormap(gray)
title('点目标原始回波信号虚部');
xlabel('距离向（采样点）');
ylabel('方位向（采样点）');
% colorbar;
figure;
imagesc(real(Srnm_sN(:,:,1)));
colormap(gray);
title('点目标原始回波信号实部');
xlabel('距离向（采样点）');
ylabel('方位向（采样点）');
colorbar;
for i=1:1:1
    Srnm=zeros(N,M);
    Srnm=Srnm_sN(:,:,i);
    %% BP成像算法
    %=========================================================================
    %BP成像算法
    %=========================================================================
    % 步骤一：距离向匹配滤波
    t_ref=tr-2*R0/c;                                             %距离向信号发射时刻生成的时间序列
    Refr=exp(j*pi*Kr*t_ref.^2).*(abs(t_ref)<=Tr/2);                 %参考信号 未取负共轭 在下面fft中进行   参考fft的性质
    Sr_temp=fftshift(fft((fftshift(Srnm.')))).'.*(ones(N,1)*conj(fftshift(fft((fftshift(Refr)))))); %距离向频域压缩
    nup=50;                                                                    %距离向升采样系数为50(平滑的作用，提高精度)
    M_up=M*nup;
    nz=M_up-M;                                                                 %补零个数
    delta_tr=1/((M_up-1)*Fr/(M-1));                                            %采样间隔（做了优化修正！）
%     sig_fr_up=[sig_fr(:,1:Nr/2),zeros(Na,nz),sig_fr(:,(Nr/2+1):Nr)];         %不用fftshift时的补零操作
    Srnm_up=[zeros(N,nz/2),Sr_temp(:,1:M/2),Sr_temp(:,(M/2+1):M),zeros(N,nz/2)];%两端补零
    Sr=fftshift(ifft(fftshift(Srnm_up.'))).';
    %显示匹配滤波结果
    figure;
    colormap(gray);colormap(gray)
    imagesc(abs(Sr));
    title('距离向匹配滤波后');
    xlabel('距离向（采样点）');
    ylabel('方位向（采样点）');
    colorbar;
       %=========================================================================
    % 步骤二：对成像区域进行网格化（N，M）
    %=========================================================================
    R=zeros(1,M);
    for ii=1:M
        R(1,ii)=Rmin+(Rmax-Rmin)/(M-1)*(ii-1);
    end
    X=zeros(1,N);
    for ii=1:N
        X(1,ii)=Xmin+(Xmax-Xmin)/(N-1)*(ii-1);
    end
    R=ones(N,1)*R;
    X=X'*ones(1,M);
    %==========================================================================
    % 步骤三：根据时延在回波域寻找相应的位置并进行成像
    %==========================================================================
    tic;
    f_back=zeros(N,M);
    pixel=zeros(N,M);
    str=['第',num2str(i),'个雷达方位后向投影计算中....'];
    h1=waitbar(0,str); 
    for ii=1:N
   %距离向：成像区域各点（图像像素）到雷达的距离（方位向：从ta(1)到ta(end)各方位向采样时间）
        t_ij=2*R_ij/c;                                                         %回波时延
        sig_rcta=Sr(ii,:);
        t_ij=round((t_ij-(2*Rmin/c-Tr/2))/delta_tr);                           %将时间转化为点数
        for aa=1:N
            for rr=1:M
                if t_ij(aa,rr)>=0&&t_ij(aa,rr)<=M_up-1
                    pixel(aa,rr)=sig_rcta(t_ij(aa,rr)+1);
                else
                    pixel=0;
                end
            end
        end
%         f_back=f_back+pixel;
        waitbar(ii/N,h1);  
    end
    close(h1);
    toc;
    figure('color', 'w');
    imagesc(abs(f_back));colormap(gray)
    title('BP算法处理后');
    xlabel('距离向（像素点）');
    ylabel('方位向（像素点）');
%     colorbar;
    
    
    
%     figure('color', 'w');
%     title('取第495行像素点观察');
%     plot(20*log10(abs(f_back(128,:))/max(abs(f_back(495,:)))));
%     xlabel('距离向（像素点）');
%     ylabel('幅度（dB）');
%     axis tight;
%     grid on;
%     figure('color', 'w');
%     title('取第824列像素点观察');
%     plot(20*log10(abs(f_back(:,824))/max(abs(f_back(:,824)))));
%     xlabel('方位向（像素点）');
%     ylabel('幅度（dB）');
%     axis tight;
%     grid on;
    
    imageArray(:,:,i)=f_back;
end
% save('imageArray','imageArray','sN','By','dt','Bs','Bx','Rmin','Rmax');























