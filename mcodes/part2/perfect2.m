% Written By : wiless.bytes@gmail.com
% Course : EE 504

close all
clc
% rand('seed',now)
x=sign(rand(1,10000)-.5);
% Hn=zeros(4,1);
% Hn(1)=0;   % Since Hn[n]=0  for n=0;
% W=2.9;
% for n=1:3
%      Hn(n+1)=1/2*(1+cos(2*pi*(n-2)/W));
% end  
CHANNELLEN=4
Hn=ones(CHANNELLEN,1);
h=Hn;
y=conv(x,h);
y=y+0.001*randn(size(y));
yy=y(400:end-400);
r0=h*h'+.001;
r1=h(2)*h(3)+h(3)*h(4);
r2=h(2)*h(4);
% [r0 r1 r2]
% RR=xcorr(y);
for TT=0:11
    YY(TT+1)=0;
for k=0:9000
    YY(TT+1)=YY(TT+1)+y(400+k)*y(400+k+TT);
end 
    YY(TT+1)=YY(TT+1)/9000;
end
    
R=zeros(11,11);
for row=1:11
    for col=1:11
        R(row,col)=YY(abs(row-col)+1);
    end
end
R;

%PP Cross Correlations 
PP=0;
for TT=1:11
    PP(TT)=0;
for k=0:9000
    PP(TT)=PP(TT)+y(400+k)*x(400+k-5+TT);
end 
    PP(TT)=PP(TT)/9000;
end
PP=PP';

EE=eig(R)';
EigenSpread=max(EE)/min(EE);
W0=inv(R)*PP;


mu=0.0075*13;

[m st w]=runLMS1(0.001,0.01);

SigmaD=var(x((400-7):9000));
Jmin=SigmaD-(PP'*W0);
% Jmin=SigmaD-(W0'*R*W0);
TR_eig=sum(EE./(2-(mu*EE)));
TREIG=sum(EE);
Jexcess=(TREIG*Jmin*mu)/2;
JLMSmin=Jmin+Jexcess;

% JLMSmin=JLMSmin*15;
% JJN=mean(Jn);

out=conv(W0,y);
J=SigmaD-var(out);
J=J+TREIG*mu*J/2


figure
plot(W0,'ko-');hold on
stem(w,'r+');
legend('Theoretical','Practical')

figure
plot(conv(W0,Hn),'ko-');hold on
stem(conv(w,Hn),'r+');
legend('Convolved Theoretical','Convolved  Practical')

figure
semilogy(m);hold on
semilogy(ones(size(m))*JLMSmin,'r')
semilogy(ones(size(m))*(J),'k')
ylim([1e-3 3])