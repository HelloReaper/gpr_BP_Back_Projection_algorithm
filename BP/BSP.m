clc
clear all
fs=40e9;
fc=7.5e9;
B=3e9;
N=1024;
M=512;
Z=512;

c=3e08;
deta_d=0.01;
tc=gauspuls('cutoff',fc,B/fc,[],-40);
t=-tc:1/fs:tc;
ps=gauspuls(t,fc,B/fc)*1000;
s=zeros(M,N);
ss=zeros(M,N);
zb=[100,600
    200,600
    300,600];
d=0.3;
mb=3;
for i=1:1:mb
    m0=zb(i,1);
    n0=zb(i,2);
    for m=1:1:M
        r=sqrt(((m0-m)*deta_d)^2+((n0-1)/fs*c/2)^2)-d;
        n1=floor(r*2/c*fs+1);
        n2=floor(sqrt((r+d)^2-d^2)*2/c*fs+1);
        s2=zeros(1,N+62);
        for n=n1:1:n2
            if n>N&atan(abs((m0-m)*deta_d/((n0-1)/fs*c/2)))>10/180*pi;
                ss(m,:)=zeros(1,N);
            else
                s2(n+16:n+46)=s2(n+16:n+46)+ps*0.95^(n-n1)/n^2;  
            end
        end
        ss(m,:)=s2(1,32:N+31);
    end
        s=ss+s;
end
tau=30;
s=s+(rand(M,N)-0.5)*max(max(s));
sar=zeros(M,N);
for n=1:1:N
    y=floor(sqrt(((-tau/2:tau/2)*deta_d).^2+((n-1)/fs*c/2)^2)*2/c*fs+1);
    for m=1:1:M  
        mag=zeros(tau+1,31);
        if m>tau/2&n>15&y+15<N&m+tau/2<M;
            for x=1:1:length(y)
                mag(x,:)=s(m-tau/2+x-1,y(x)-15:y(x)+15);
    %                   mag(x,:)=s(m-tau/2+x-1,y(x));
            end
            sar(m,n)=sum(abs(sum(mag)));
        end
    end
end
imagesc(sar)