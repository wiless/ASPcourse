% The main routine. This calls the runLMS1.m & runNLMS1  program with two different 
% runLMS1 Functions Run the simulation of LMS algorithm with Narrowband Channel
% runNLMS1 Functions Run the simulation of LMS algorithm with Narrowband Channel
% stepsizes & Variances
% Written By : wiless.bytes@gmail.com
% Course : EE 504
%
% Last Revised Date : 31-Mar-2004
close all
clear
clc

[mse(1,:) Wn Hn]=runLMS1(0.001,0.0075); % Variance= 0.001 Step size = 0.0075
[mse(2,:) STEPS(2,:)]=runNLMS1(0.001,0.0075*5,0.01);   % Variance= 0.001 Step size = 0.0075
[mse(3,:) STEPS(3,:)]=runNLMS1(0.001,0.0075*10,0.01);   %Variance= 0.001 Step size = 0.0075
[mse(4,:) STEPS(4,:)]=runNLMS1(0.001,0.0075*15,0.01);   %Variance= 0.001 Step size = 0.0075

STEPS(1,:)=0.0075*ones(size(STEPS(2,:)));
% The K corresponds to the Combined Delay of Channel & Adaptive Filter , as only after the 7th bit 
% the Transversal filter moves to a non-zero coefficients.
figure
K=10;
semilogy((K+1):2000,mse(1,(K+1):end),'b');hold on;
semilogy((K+1):2000,mse(2,(K+1):end),'k');
semilogy((K+1):2000,mse(3,(K+1):end),'r');
semilogy((K+1):2000,mse(4,(K+1):end),'g');
grid on;
legend('LMS stepsize = 0.0075','NLMS {\alpha} = 0.0075*5','NLMS {\alpha} = 0.0075*10','NLMS {\alpha} = 0.0075*15',0);
title('LMS & NLMS Performance with different Stepsize ');
xlabel('No of Iterations');
ylabel('Mean Square Error');
ylim([10e-3 2])

figure
K=7;
plot((K+1):2000,STEPS(1,(K+1):end),'b','linewidth',2);hold on;
plot((K+1):2000,STEPS(2,(K+1):end),'k');
plot((K+1):2000,STEPS(3,(K+1):end),'r');
plot((K+1):2000,STEPS(4,(K+1):end),'g');
grid on;
legend('LMS stepsize = 0.0075','NLMS {\alpha} = 0.0075*5','NLMS {\alpha} = 0.0075*10','NLMS {\alpha} = 0.0075*15',0);
title('LMS {\mu}=.0075 & NLMS Stepsize {\alpha}/ {\aleph}orm(U[n]) @ each Iterations');
xlabel('No of Iterations');
ylabel('Step Size');
% ylim([-1 3])
text(1010,0.15,'{\mu}=.0075')

% The following plots the Actual Channel Coefficients & 
% Adapted Transversal Filter Coefficients after 1500 iterations
% figure;
% CASCADED=conv(Hn,Wn);
% Hn(14)=0;Wn(14)=0; % For better visualization 
% 
% subplot(3,1,1);stem(0:13,Hn);title('Channel Tap Coefficients H[n]');ylim([-2 2]);grid
% subplot(3,1,2);stem(0:13,Wn);title('Transversal Filter Coefficients W[n]');ylim([-2 2]);grid
% subplot(3,1,3);stem(0:13,CASCADED);title('Cascaded Hn & Wn, Response (W[n] convolve H[n])');ylim([-2 2]);grid




