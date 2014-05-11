% Program : Simulation of NLMS Algorithm
% Written By : wiless.bytes@gmail.com
% Course : EE 504

% Last Revised Date : 31-Mar-2004
% 
% FUNCTION DESCRIPTION : Takes three input Arguments,and returns three output variables
% Input : VARIANCE : is variance of AWGN added to the Signal Source of +1,-1
%         STEPSIZE : is the stepsize of NLMS Update equation
%         BETA     : is a small factor (Optional,Default =0 )added to Norm of Energy of input Vector see [Doc],
%                       
%
% Output : MSE     : Returns a Vector 1x1500 Mean Square Errors,where each element corresponds
%                    to the Error at that Iteration.
%          STEPS   : Array of Steps at each Iterations
%          Wn      : The final Transversal Filter Coefficients of 11x1    
%
%
% e,g [MSE Steps Wn]=runNLMS1(0.01,0.025,0.01) calls the NLMS with Variance = 0.01 & step size=0.025

function [MSE,STEPS,Wn]=runNLMS1(VARIANCE,STEPSIZE,BETA)

if nargin==2
    BETA=0;
end
if nargin==0
disp('Try help runNLMS ');
STEPSIZE=0.0075;                                 % Stepsize mule
VARIANCE=0.01;                                  % AWGN parameter
BETA=0;
elseif nargin==1
disp('Requires two Arguments VARIANCE & STEPSIZE');
disp('Try help runNLMS ');
MSE=[];
return;
end


NO_OF_SIMULATION=200;
NOOFBITS=2500;                                   % No of Data Bits
ADAPTIVE_ITERATIONS=2000;             % No of Iterations for which T_Filter Adapts

%Actual Channel Coefficients  
CHANNELLEN=10;
NOOFTAPS=11;                                      % Transversal Filter TAPS
K=10;                                              %  Delay Parameter
%Initializing Channel coefficients as per eq (1), Ref Document
W=3.1; 
Hn=ones(CHANNELLEN,1);
% Hn(1)=0;   % Since Hn[n]=0  for n=0;
% for n=1:3
%     Hn(n+1)=(1/2)*(1+cos(2*pi*(n-2)/W));
% end                                         
% Transversal Filter Coefficients
Wn=zeros(NOOFTAPS,1);                   % All coefficients initialized with zero.



%  RUN THE SIMULATION FOR  NO_OF_SIMULATION =200 TIMES
MSE=zeros(1,ADAPTIVE_ITERATIONS);
STEPS=zeros(1,ADAPTIVE_ITERATIONS);
text=sprintf('Simulation with Variance = %2.4f & Stepsize = %1.4f',VARIANCE,STEPSIZE);
h=waitbar(0,text);
for SIMULATION=1:NO_OF_SIMULATION
    %sprintf('Simulation Progress',SIMULATION)
    waitbar(SIMULATION/NO_OF_SIMULATION,h);
    % Generation of Uniform Random Data +1 ,-1, 
%      nn=1:NOOFBITS;
    Xn= sign(rand(NOOFBITS,1)-0.5); %Xn= sin(2*pi*1*nn/W)';    % Random signals 
  
    %Delayed input data used as Desired sequence
    Dn=[zeros(K,1);Xn(K+1:end)];
    %Generate AWG Random Variables with Variance 'VARIANCE'
    Vn=randn(NOOFBITS+CHANNELLEN-1,1);   % Generates Guassian Random Variable of  Variance =1 
    Vn= sqrt(VARIANCE)*Vn;
    
    % Generating the INPUT to the TRANSVERSAL FILTER, u[n]
    temp=conv(Hn,Xn);
    Un=temp + Vn;
    
    W_vector=Wn;
    
    for iteration=1:ADAPTIVE_ITERATIONS
        U_vector=Un(iteration:iteration+NOOFTAPS-1);  % Next U_vector        
        % Evaluate Error 
        En=Dn(iteration) - ( W_vector' )*U_vector;
        % Update Equation (2) Refer Document
        STEPsize=(STEPSIZE/(BETA+sum(U_vector.*U_vector)));  %W_vector=W_vector+STEPSIZE*U_vector*En;
	    W_vector=W_vector+STEPsize*U_vector*En;
	    
        steps(iteration)=STEPsize;
        mse(iteration)=(En)^2;
    end
    MSE=MSE+mse;
    STEPS=STEPS+steps;
end
MSE=MSE/NO_OF_SIMULATION;
STEPS=STEPS/NO_OF_SIMULATION;
Wn=W_vector; % The Freezed Transversal Filter Coefficients.
Hn=Hn;       % The Channel Coefficients  
close(h)

