% Program : Simulation of LMS Algorithm
% Written By : wiless.bytes@gmail.com
% Course : EE 504

% Last Revised Date : 31-March-2004
%
% FUNCTION DESCRIPTION : Takes two input Arguments,and returns three output variables
% Input : VARIANCE : is variance of AWGN added to the Signal Source of +1,-1
%         STEPSIZE : is the stepsize of LMS Update equation
%
% Output : MSE     : Returns a Vector 1x1500 Mean Square Errors,where each element corresponds
%                    to the Error at that Iteration.
%          Wn      : The final Transversal Filter Coefficients of 11x1    
%          Hn      : The Actual Channel Coefficients
%
% e,g [MSE Wn Hn]=runLMS1(0.01,0.025) calls the LMS with Variance = 0.01 & step size=0.025
%
function [MSE,Wn,Hn]=runLMS1(VARIANCE,STEPSIZE)
if nargin==0
disp('Try help runLMS ');
STEPSIZE=0.0075                                % Stepsize mule
VARIANCE=0.001                                 % AWGN parameter
elseif nargin==1
disp('Requires two Arguments VARIANCE & STEPSIZE');
disp('Try help runLMS ');
MSE=[];
return;
end


NO_OF_SIMULATION=200;
NOOFBITS=2500;                                   %No of Data Bits
ADAPTIVE_ITERATIONS=2000;             % No of Iterations for which T_Filter Adapts

NOOFTAPS=11;                                      % Transversal Filter TAPS
% Transversal Filter Coefficients
K=7;                                                           %  Delay Parameter
%Actual Channel Coefficients  
CHANNELLEN=4;
%Initializing Channel coefficients as per eq (1), Ref Document
W=3.1; 
Hn=ones(CHANNELLEN,1);
% Hn(1)=0;   % Since Hn[n]=0  for n=0;
% for n=1:3
%      Hn(n+1)=1/2*(1+cos(2*pi*(n-2)/W));
% end                                         
Wn=zeros(NOOFTAPS,1);                   % All coefficients initialized with zero.


%  RUN THE SIMULATION FOR  NO_OF_SIMULATION =200 TIMES
MSE=zeros(1,ADAPTIVE_ITERATIONS);
text=sprintf('Simulation with Variance = %2.4f & Stepsize = %1.4f',VARIANCE,STEPSIZE);
h=waitbar(0,text);
 % nn=1:NOOFBITS;
    %Xn=sign(rand(NOOFBITS,1)-0.5);       % Random signals 
for SIMULATION=1:NO_OF_SIMULATION
    %sprintf('Simulation Progress',SIMULATION)
    waitbar(SIMULATION/NO_OF_SIMULATION,h);
    % Generation of Uniform Random Data +1 ,-1, 
    %nn=1:NOOFBITS;
    Xn=sign(rand(NOOFBITS,1)-0.5);       % Random signals 
    %Xn= sin(2*pi*nn/5)';    % Random signals 
 
    %Delayed input data used as Desired sequence
    Dn=[zeros(K,1);Xn(K+1:end)];
    %Generate AWG Random Variables with Variance 'VARIANCE'
    Vn=randn(NOOFBITS+CHANNELLEN-1,1);   % Generates Guassian Random Variable of  Variance =1 
    Vn= sqrt(VARIANCE)*Vn;
    
    % Generating the INPUT to the TRANSVERSAL FILTER, u[n]
    temp=conv(Hn,Xn);
    Un=temp+Vn(1:length(temp));% temp+ Vn;
%     if(SIMULATION==1)
%         plot(temp);hold on;
%         plot(Un,'r');
%     pause    
%     end
        
    W_vector=Wn;
    
    for iteration=1:ADAPTIVE_ITERATIONS
        U_vector=Un(iteration:iteration+NOOFTAPS-1);  % Next U_vector        
        % Evaluate Error 
        En=Dn(iteration) - ( W_vector' )*U_vector;
        % Update Equation (2) Refer Document
        W_vector=W_vector+STEPSIZE*U_vector*En;
        mse(iteration)=(En)^2;
    end
    MSE=MSE+mse;
end
Wn=W_vector; % The Freezed Transversal Filter Coefficients.
Hn=Hn;       % The Channel Coefficients  
MSE=MSE/NO_OF_SIMULATION;
close(h)

