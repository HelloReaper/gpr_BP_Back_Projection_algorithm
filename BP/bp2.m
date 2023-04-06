%BPA ���Ŀ�굥վ SAR
% �������ֻ����һ����������
%parametcrs from Table 6,1
%date: 2010/10/14
clc;
clear all;
close all;

%% ��������
%=========================================
c=3e8;
j=sqrt(-1);
pi=3.1416;

fc=5.3e9;   
lamda=c/fc;
D=4;                          % ��λ�����߳ߴ�
Va=150;                       % ��Ч�״��ٶ�
Kr=20e12;                     % �����Ƶ��
Tr=2.5e-6;                    % ��������ʱ��
sq_ang=3.5/180*pi;            % ����б�ӽ� ��������б�ӽǣ�����ά�ϳɿ׾��������ӣ� 

Br=Kr*Tr;                     % ����
Frfactor=1.2;                 % �������������
Fr=Br*Frfactor;               % ���������Ƶ��
Ba=0.886*2*Va*cos(sq_ang)/D;  % �����մ��� 
Fafactor=1.2;                 % ��λ���������
Fa=Ba*Fafactor;               % ��λ�����Ƶ��

R_near=2e4;                   % ��������(�������λ��б��)
R_far=R_near+1000;            % ����Զ��(�������λ��б��)


La_near=0.886*R_near*lamda/(cos(sq_ang).^2)/D;    % �������˺ϳɿ׾�����            
La_far=0.886*R_far*lamda/(cos(sq_ang).^2)/D;      % ����Զ�˺ϳɿ׾�����  Ϊɶ��ƽ������ͼ���֪���ˣ���һ��cos��Ϊб�ӣ�Ŀ�����״�ľ����Զ��Ҫ����һ��cos���ڶ���cos�����ڼ��ι�ϵ�����ģ���Ϊб��֮�󳤶Ȳ���ֱ���ð뾶���ԽǶȵõ�����Ӧ���ڴ˵Ļ������ٳ���һ��cos
Tc_near=-R_near*tan(sq_ang)/Va;              % �������˲������Ĵ���ʱ��(���������λ��Ϊ�ο�ʱ��)
Tc_far=-R_far*tan(sq_ang)/Va;                % ����Զ�˲������Ĵ���ʱ��(���������λ��Ϊ�ο�ʱ��)
fdc=2*Va*sin(sq_ang)/lamda;                  % ����������Ƶ��


Rmin=sqrt(R_near^2+(Tc_near*Va+La_near/2)^2);  % �״�͸����������б��           
Rmax=sqrt(R_far^2+(Tc_far*Va-La_far/2)^2);     % �״�͸���������Զб��          



disp('����');
disp('�״��ʵ�������');disp(0.886*lamda/D);
disp('�״��б�ӽ�');disp(sq_ang/pi*180);
disp('�״�ͳ���������б��:');disp(Rmin);
disp('�״�ͳ��������Զб��:');disp(Rmax);
disp('����ֱ���:');disp(0.886*(c/2/Br));
disp('��λ�ֱ���:');disp(0.886*Va/Ba);                 %??????????????????????????????
disp('����������:');disp(fdc);

%% �ز�ģ��
%====================================================
Nr=(2*Rmax/c+Tr-2*Rmin/c)*Fr;
Nr=2^nextpow2(Nr);                                       % �������������
tr=linspace(-Tr/2+2*Rmin/c,Tr/2+2*Rmax/c,Nr);            % ���������ʱ��(��ÿ����������ʱ��Ϊ�ο�ʱ��)        ΪʲôҪ������
Fr=(Nr-1)/(Tr/2+2*Rmax/c-(-Tr/2+2*Rmin/c));              % ���������Ƶ��
Na=((Tc_near+La_near/2/Va)-(Tc_far-La_far/2/Va))*Fa;
Na=2^nextpow2(Na);                                       % ��λ���������
ta=linspace(Tc_far-La_far/2/Va,Tc_near+La_near/2/Va,Na); % ��λ�����ʱ��(���������λ��Ϊ�ο�ʱ��)
Fa=(Na-1)/(Tc_near+La_near/2/Va-(Tc_far-La_far/2/Va));   % ��λ�����Ƶ��

disp('�ɷ���ά����Ƶ�����Ƶ��״��볡������һ�����Զб�ࣺ');disp(1/Fa*c/2);

Rpt=[R_near R_near R_near+1000 R_near+1000];                     % ��Ŀ��λ��(б��)
Ypt=[10 -10 10 -10];
Npt=length(Rpt);                                         % Ŀ����Ŀ
La=0.886*Rpt*lamda/(cos(sq_ang))/D;                      % ÿ��Ŀ��ĺϳɿ׾�����
Tc=-Rpt*tan(sq_ang)/Va;                                  % ÿ��Ŀ��Ĳ�������ʱ��
                               

Y_high=max(Ypt)+50;      % ȷ����������ķ�Χ����ʹ�����Ŀ��㣻
Y_low=min(Ypt)-50;       % ���������ǣ�R_right-R_left) *(Y_high-Y_low) ��һƬ����
R_left=R_near-50;
R_right=R_far+50;

disp('��Ŀ������:');disp(Npt);
disp('����ά��������:');disp(Nr);
disp('����ά��������:');disp(Na);
disp('����ά����Ƶ��:');disp(Fr);
disp('����ά����Ƶ��:');disp(Fa);
disp('��С�ϳɿ׾�����:');disp(0.886*R_near*lamda/(cos(sq_ang))/D);
disp('���ϳɿ׾�����:');disp(0.886*(R_near+1000)*lamda/(cos(sq_ang))/D);
disp('�״��ƶ���Χ');disp((Tc_near+La_near/2/Va)-(Tc_far-La_far/2/Va)*Va);

sig=zeros(Na,Nr);
for k=1:Npt
	delay=2/c*sqrt(Rpt(k)^2+(Ypt(k)-ta*Va).^2);                            % ��Ŀ�굽�״�ÿ����λ����ʱ��
	Dr=ones(Na,1)*tr-delay'*ones(1,Nr);                                   
	sig=sig+exp(j*pi*Kr*Dr.^2-j*2*pi*fc*delay'*ones(1,Nr))...              % �����ز��źţ���һ����λ��Ϊ���Ե�Ƶ��������λ���ڶ�����λ��Ϊ����ʵ���������λ
            .*(abs((ta-(Tc(k)+Ypt(k)/Va))'*ones(1,Nr))<=La(k)/2/Va)...     % <= ������ȡֵ��Χ; ����ά����ʱ����Ŀ�����������ʱ�̵�ʱ���Ӧ��С�ڸ�Ŀ���׾�ʱ���һ��
            .*(abs(Dr)<=Tr/2);                                             % ���������֪��Ϊɶƥ���˲�ѹ����Ľ�����м䣬��Ϊ��һ��ʼ�����м�
end

figure('Name','�ز��źŷ���');imagesc(real(sig)) ;
colorbar
title('�ز��źŷ���');xlabel('������(������)');ylabel('��λ��(�����㣩'); 
figure('Name','�ز��ź���λ'); imagesc(abs(angle(sig)));
title('�ز��ź���λ');xlabel('������(������)');ylabel('��λ�򣨲����㣩'); 
%==============================================================
%% BP �㷨
%% ����һ��������ƥ���˲�
sig_rd=fft(sig,[],2);
fr=-1/2:1/Nr:(1/2-1/Nr);
fr=fftshift(fr*Fr);
%  fr=0:Fr/Nr:(Fr/2-Fr/Nr);
filter_r=ones(Na,1)*exp(j*pi*fr.^2/Kr);      %��0��tau���ź�������Ҷ�任����Ƶ���Ծ���ԭ��
sig_rd=sig_rd.*filter_r;
nup=100;                           % ������������ϵ��Ϊ100
Nr_up=Nr*nup;                      % ������֮���Ƶ���������
nz=Nr_up-Nr;                       % ��Ҫ����ĸ���
dtr=1/nup/Fr;                      % ����֮���ʱ��ֱ���
sig_rd_up=zeros(Na,Nr_up);
sig_rd_up=[sig_rd(:,1:Nr/2),zeros(Na,nz),sig_rd(:,(Nr/2+1):Nr)];
sig_rdt=ifft(sig_rd_up,[],2);
figure('Name','������ƥ���˲���');imagesc(abs(sig_rdt));colorbar
title('������ƥ���˲���');xlabel ('������(������)');ylabel('��λ�򣨲�����)');
figure('Name','��λ��128����������ź�');plot(abs(sig_rdt(128,:)));
figure('Name','��λ��128����������ź�');plot(real(sig_rdt(128,:)));

%% ����� �Գ�������������񻯣�Na*Nr)
R=zeros(1,Nr);
for ii=1:Nr
%   R(1,ii)=R_near+(R_far-R_near)/(Nr-1)*(ii-1);
    R(1,ii)=R_left+(R_right-R_left)/(Nr-1)*(ii-1);
end
Y=zeros(1,Na);
for ii=1:Na
	Y(1,ii)=Y_low+(Y_high-Y_low)/(Na-1)*(ii-1);
end


R=ones(Na,1)*R;
Y=Y'*ones(1,Nr);

%% ������������ʱ���ڻز���Ѱ����Ӧλ�ò����г���
f_back=zeros(Na,Nr) ;
m_back = zeros(Na,Nr);
gridpoint = zeros(Na,Nr);

for ii=1:Na
%ii=100;
	R_ij=sqrt(R.^2+(Y-Va*ta(ii)).^2);  % ÿ���������ÿһ�״�λ�õľ���
	t_ij=2*R_ij/c;                     % ÿ���������ÿһ�״�λ�õ�ʱ��
    t_ij=round((t_ij-(2*Rmin/c-Tr/2))/dtr);   % ÿ�����������ھ��������ʼʱ�̵Ĳ���λ��
    
    
 	it_ij=(t_ij>0&t_ij<=Nr_up);
 	t_ij=t_ij.*it_ij+Nr_up*(1-it_ij); %% ��������Ϊ���Ԫ����Nr_up����
 
	sig_rdta=sig_rdt(ii,:);
%     figure('Name','��λ�ڸ���������ź�');plot(abs(sig_rdta));
    
	sig_rdta(Nr_up)=0;
    if ii == 128
    gridpoint = abs(sig_rdta(t_ij));
    figure;
    imagesc(gridpoint);
    figure;
    imagesc(t_ij);
    end
    
	f_back=f_back+sig_rdta(t_ij).*exp(1i*4*pi*R_ij/lamda);  
    m_back = m_back + abs(sig_rdta(t_ij));
%   f_back=f_back+abs(abs(sig_rdta(t_ij)));
   

end


figure('Name','BP�㷨�����ʹ����λУ��'); imagesc(abs(f_back));
title('BP�㷨�����');xlabel('������'); ylabel('��λ��');
figure('Name','BP�㷨�����ʹ�þ���ֵ��Ӵ���'); mesh(abs(f_back));
title('BP�㷨�����');xlabel('������'); ylabel('��λ��');

figure('Name','BP�㷨�����ʹ�þ���ֵ��Ӵ���'); imagesc(abs(m_back));
title('BP�㷨�����');xlabel('������'); ylabel('��λ��');
% ʹ�þ���ֵ��Ӵ���Ч�����ã�ԭ������Ƕ���ѹ�����sinc�������������ٽ�
% �����㣬���ǵľ���ֵ���������λ����Զ


% figure('Name','BP�㷨�����'); imagesc(abs(m_back));
% title('BP�㷨�����');xlabel('������'); ylabel('��λ��');



