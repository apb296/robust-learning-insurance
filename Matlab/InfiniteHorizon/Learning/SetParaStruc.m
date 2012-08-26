Para.BenchMark=1;

CompStr=computer;
switch CompStr

case 'PCWIN'

BaseDirectory='C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\';
SL='\';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/Project Robust Learning/Matlab/InfiniteHorizon/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/RobustLearning/Mfiles/InfiniteHorizon/';

SL='/';
end

CompEconPath=[BaseDirectory 'compecon2011' SL 'CEtools' SL];
PlotPath=[BaseDirectory 'Learning' SL 'Plots' SL];
TexPath=[BaseDirectory 'Learning' SL 'Tex' SL];
DataPath=[BaseDirectory 'Learning' SL 'Data' SL];
NoLearningPath=[BaseDirectory];
LearningPath=[BaseDirectory 'Learning' SL];



mkdir(PlotPath)
mkdir(TexPath)
mkdir(DataPath)
Para.CompEconPath=CompEconPath;
Para.PlotPath=PlotPath;
Para.TexPath=TexPath;
Para.DataPath=DataPath;
Para.NoLearningPath=NoLearningPath;
Para.LearningPath=LearningPath;
addpath(genpath(Para.CompEconPath));

global ra;

c=1;
ybar=1;
g=.25;
%g=0;
alpha1=.5;
alpha2=.9;
beta1=.5;
beta2=.9;
alpha =[ alpha1;alpha2;alpha2];
beta=[beta1;beta2;beta2];
theta11=.500000000;
theta12=.50000000;
delta=.8;
theta11*delta/theta12-1;
ra=.5;
pi1=.1;

% Aggregate States
yl=ybar*(1-g);
yh=ybar*(1+g);
%yl=ybar*.1;
%yh=ybar;
YS=[yl;yh];
Y=[yl;yl;yh;yh];
% Idiosyncratic States
sl=.2;
sh=.8;
S=[sl;sh];
% 2 Models
M=[1;2];
MSize=length(M);
P_M=[1 0;
     0 1];
 Para.P_M=P_M;
%Prior

% Theta(i,j)=agent(i) operator(j)
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];

%Model 1 
p_ylow_ylow(1)=.5;
p_ylow_yhigh(1)=1-p_ylow_ylow(1);
p_yhigh_yhigh(1)=.5;
p_yhigh_ylow(1)=1-p_yhigh_yhigh(1);
p_slow_ylow(1)=.5;
p_shigh_ylow(1)=1-p_slow_ylow(1);
p_slow_yhigh(1)=.5;
p_shigh_yhigh(1)=1-p_slow_yhigh(1);
%Model 2
p_ylow_ylow(2)=.9;
p_ylow_yhigh(2)=1-p_ylow_ylow(2);
p_yhigh_yhigh(2)=.9;
p_yhigh_ylow(2)=1-p_yhigh_yhigh(2);
p_slow_ylow(2)=.9;
p_shigh_ylow(2)=1-p_slow_ylow(2);
p_slow_yhigh(2)=.5;
p_shigh_yhigh(2)=1-p_slow_yhigh(2);



for m =1:MSize
    P(:,:,m) = [p_ylow_ylow(m)*p_slow_ylow(m) p_ylow_ylow(m)*p_shigh_ylow(m) p_ylow_yhigh(m)*p_slow_yhigh(m) p_ylow_yhigh(m)*p_shigh_yhigh(m) 
        p_ylow_ylow(m)*p_slow_ylow(m) p_ylow_ylow(m)*p_shigh_ylow(m) p_ylow_yhigh(m)*p_slow_yhigh(m) p_ylow_yhigh(m)*p_shigh_yhigh(m) 
        p_yhigh_ylow(m)*p_slow_ylow(m) p_yhigh_ylow(m)*p_shigh_ylow(m) p_yhigh_yhigh(m)*p_slow_yhigh(m) p_yhigh_yhigh(m)*p_shigh_yhigh(m) 
        p_yhigh_ylow(m)*p_slow_ylow(m) p_yhigh_ylow(m)*p_shigh_ylow(m) p_yhigh_yhigh(m)*p_slow_yhigh(m) p_yhigh_yhigh(m)*p_shigh_yhigh(m) 
        ];
end
%Define Struct for Para
Para.delta=delta;
Para.Y=Y;
Para.M=M;
Para.Theta=Theta;
Para.P=P;
Para.RA=ra;
Para.MSize=MSize;
% if exist('m_true')==0
% m_true=1;
% end

%Para.m=m_true;
%TH=[1]
pi=[pi1;(1-pi1)];
Pi=[pi pi];
C=['r','r','b','b'];

Para.Pi=Pi;

Para.ZSize=4;
ctol=1e-5;
grelax=.9;
Para.ctol=ctol;
Para.grelax=grelax;
% Parameters for the approximation
VGridSize=25;
VGridInit=round(.2*VGridSize);
% use this for Cheb approximation
OrderOfApproximation=7;
OrderOfApproximationPi=3;
OrderOfApproximationV=7;
% use this for spline approximation
%OrderOfApproximationPi=3;
%OrderOfApproximationV=4;
OrderOfSpline=3;
NIter=101;
Para.NIter=NIter;
Para.StateName={'$(y_{l},s_{l})$','$(y_{l},s_{h})$','$(y_{h},s_{l})$','$(y_{h},s_{h})$'};
Para.N=10000;
