%% Name: ����Բ��ȫϢ3DSAR��Ŀ�����(BP-CS�㷨)
%  ģʽ���շ�����
%  ����Chirp�źţ�
%  Date: 2017.7.18 
%  Author��������
% ˵���� ����8���״����ʵ�ָ߶���ķֱ�
%% ��������
clc;close all; clear all;
c=3e8;  %����
%����SAR
disp('Spaceborne Circle SAR')
%%�״����
fc=5.3e9;                                                               %��Ƶ C����
lamda=c/fc;                                                             %���� 
Br=30e6;                                                                %���Ե�Ƶ�źŵ�Ƶ�ʴ��� 30MHz
Tr=40e-6;                                                               %�������ʱ��
Kr=Br/Tr;                                                               %��Ƶ��
Fr=1.2*Br;                                                              %��ʱ�������  1.2������
H=800e3;                                                                %SAR�ľ�������� 800km
theta=26.288/180*pi;                                                    %�����Ǧ�(���ӽ�)
Yc=H*tan(theta);
R0=H/cos(theta);
rouY = c/(Br*2);                                                        % ������ֱ���
gama = 0*pi/180;                                                        %��λ��б�ӽ�  ������ side-looking
D=10;                                                                   %SAR ��λ�����߳���
rouX = D/2;                                                             %��λ��ֱ���
V=7000;                                                                 %SAR�ٶ�

Ka=-2*V^2/lamda/R0;                                                    %doppler ��Ƶ��
Lsar=0.886*lamda*R0/D;                                                 %SAR �ϳɿ׾�����
Tsar=Lsar/V; 
Ba=abs(Ka*Tsar);                                                        %doppler ��Ƶ������λ����
PRF=1.2*Ba;                                                                 %�����ظ�Ƶ��

%%Ŀ������
Xmin=-200;                                                                %Ŀ�����ķ�λ��Χ[Xmin,Xmax]
Xmax=200; 
%��λʱ������
PRT=1/PRF;                                                              %�����ظ����
ds=PRT;                                                                 %��ʱ�����������                               
Nslow=2048;                                      %��ʱ���������
%Nslow=2^nextpow2(Nslow);                                                %д��2��ָ�� for fft
ta=-PRT*Nslow/2:PRT:PRT*(Nslow/2-1);                     %��ʱ������ɢʱ������


%����ʱ������
Y0=1000;  %�ؾ������Χ[Yc-Y0,Yc+Y0]                                                                      
dt=1/Fr;                                                               %��ʱ�����������                                                           %SAR �ϳɿ׾�ʱ��
                                            
Rmin=sqrt(H^2+(Yc-Y0)^2);                                                %SAR��һ���׾���������̾���                                         
Rmax=sqrt(H^2+(Yc+Y0)^2);                                               %SAR��һ���׾������������
Nfast=ceil(2*(Rmax-Rmin)/c/dt+Tr/dt);                                   %��ʱ����Ĳ�����
tr=linspace(2*Rmin/c-Tr/2,2*Rmax/c+Tr/2,Nfast);                       %��ʱ�������ɢʱ������
r=tr*c/2;%������ľ�������

%%�����ֱ���
DR=c*dt/2;                                                              %������ֱ���
DX=V*ds;                                                                 %��λ��ֱ���
%% Ŀ�����   ������
% Rpt=[0 20 20 20 20];                                                     %Ŀ����λ��,����λ��
% thetaT=[0,0,0,0,0];                                                        %����
% alpha=[0,pi/4,3*pi/4,5*pi/4,7*pi/4];                                       %��λ��

Rpt=[R0-5 R0+5 R0-5 R0+5];                                                     %Ŀ����λ��,����λ��
Xpt=[-5 -5 5 5]; 
Spt=[10 20 10 20];



Npt=length(Rpt);                                                           %Ŀ�����
%% ���߲���
sN=9;%9������
Bx=0;
By=0;%
Bs=0;%�߶Ȼ���

K=Npt;                                                                   %Ŀ�����
N=Nslow;                                                                %��ʱ�����������ȣ�������������
M=Nfast;                                                                %��ʱ������������

Srnm_sN=zeros(N,M,sN);  
for i=1:1:sN
    for k=1:1:K
        sigma=1;
        Dslow=ta*V-Xpt(k);                                                  %SAR��Ŀ�귽λ������γɵ�����
        R=sqrt(Dslow.^2+(Rpt(k)-By(i))^2+(Bs(i)-Spt(k))^2);                         %���ɾ����������    ������������
        tau=2*R/c;                                                          %���ɾ�������ӳ�����
        Dfast=ones(N,1)*tr-tau'*ones(1,M);                                  %����t-tao����
        phase=pi*Kr*Dfast.^2-(4*pi/lamda)*(R'*ones(1,M));                  %�ز���λ����
        Srnm_sN(:,:,i)=Srnm_sN(:,:,i)+sigma*exp(j*phase).*(abs(Dfast)<=Tr/2).*((abs(Dslow)<=Lsar/2)'*ones(1,M));
    end
end


figure;
imagesc(imag(Srnm(:,:,1)));colormap(gray)
title('��Ŀ��ԭʼ�ز��ź��鲿');
xlabel('�����򣨲����㣩');
ylabel('��λ�򣨲����㣩');
% colorbar;
figure;
imagesc(real(Srnm_sN(:,:,1)));
colormap(gray);
title('��Ŀ��ԭʼ�ز��ź�ʵ��');
xlabel('�����򣨲����㣩');
ylabel('��λ�򣨲����㣩');
colorbar;
for i=1:1:1
    Srnm=zeros(N,M);
    Srnm=Srnm_sN(:,:,i);
    %% BP�����㷨
    %=========================================================================
    %BP�����㷨
    %=========================================================================
    % ����һ��������ƥ���˲�
    t_ref=tr-2*R0/c;                                             %�������źŷ���ʱ�����ɵ�ʱ������
    Refr=exp(j*pi*Kr*t_ref.^2).*(abs(t_ref)<=Tr/2);                 %�ο��ź� δȡ������ ������fft�н���   �ο�fft������
    Sr_temp=fftshift(fft((fftshift(Srnm.')))).'.*(ones(N,1)*conj(fftshift(fft((fftshift(Refr)))))); %������Ƶ��ѹ��
    nup=50;                                                                    %������������ϵ��Ϊ50(ƽ�������ã���߾���)
    M_up=M*nup;
    nz=M_up-M;                                                                 %�������
    delta_tr=1/((M_up-1)*Fr/(M-1));                                            %��������������Ż���������
%     sig_fr_up=[sig_fr(:,1:Nr/2),zeros(Na,nz),sig_fr(:,(Nr/2+1):Nr)];         %����fftshiftʱ�Ĳ������
    Srnm_up=[zeros(N,nz/2),Sr_temp(:,1:M/2),Sr_temp(:,(M/2+1):M),zeros(N,nz/2)];%���˲���
    Sr=fftshift(ifft(fftshift(Srnm_up.'))).';
    %��ʾƥ���˲����
    figure;
    colormap(gray);colormap(gray)
    imagesc(abs(Sr));
    title('������ƥ���˲���');
    xlabel('�����򣨲����㣩');
    ylabel('��λ�򣨲����㣩');
    colorbar;
       %=========================================================================
    % ��������Գ�������������񻯣�N��M��
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
    % ������������ʱ���ڻز���Ѱ����Ӧ��λ�ò����г���
    %==========================================================================
    tic;
    f_back=zeros(N,M);
    pixel=zeros(N,M);
    str=['��',num2str(i),'���״﷽λ����ͶӰ������....'];
    h1=waitbar(0,str); 
    for ii=1:N
   %�����򣺳���������㣨ͼ�����أ����״�ľ��루��λ�򣺴�ta(1)��ta(end)����λ�����ʱ�䣩
        t_ij=2*R_ij/c;                                                         %�ز�ʱ��
        sig_rcta=Sr(ii,:);
        t_ij=round((t_ij-(2*Rmin/c-Tr/2))/delta_tr);                           %��ʱ��ת��Ϊ����
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
    title('BP�㷨�����');
    xlabel('���������ص㣩');
    ylabel('��λ�����ص㣩');
%     colorbar;
    
    
    
%     figure('color', 'w');
%     title('ȡ��495�����ص�۲�');
%     plot(20*log10(abs(f_back(128,:))/max(abs(f_back(495,:)))));
%     xlabel('���������ص㣩');
%     ylabel('���ȣ�dB��');
%     axis tight;
%     grid on;
%     figure('color', 'w');
%     title('ȡ��824�����ص�۲�');
%     plot(20*log10(abs(f_back(:,824))/max(abs(f_back(:,824)))));
%     xlabel('��λ�����ص㣩');
%     ylabel('���ȣ�dB��');
%     axis tight;
%     grid on;
    
    imageArray(:,:,i)=f_back;
end
% save('imageArray','imageArray','sN','By','dt','Bs','Bx','Rmin','Rmax');























