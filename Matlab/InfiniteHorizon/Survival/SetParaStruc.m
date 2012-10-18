% Technology : Aggregate endowment Y
ybar=1;
g=.3;
yHigh=ybar*(1+g);
yLow=ybar*(1-g);
Y=[yLow yHigh]';

% Preferences
theta_1=.5; % Concerns for ambiguity Agent 1
theta_2=theta_1; % Concerns for ambiguity Agent 1
delta=.9; % common time discount factor
gamma=.5; % common utility curvature

% Reference models
P1=[.4 .6;
    .4 .6];  % Agent 1
P2=[.6 .4;
    .6 .4]; % Agent 2


% Parameters for the approximation
ApproxMethod='spli';
OrderOfApproximation=3;
OrderOfApproximationPi=5;
OrderOfApproximationV=15;
OrderOfSpline=3;
VGridDensityFactor=2;
PiGridDensityFactor=2;
NIter=150;
grelax=.95;



% store the Para struc
Para.Y=Y;
Para.YSize=length(Para.Y);
Para.theta_1=theta_1;
Para.theta_2=theta_2;
Para.delta=delta;
Para.gamma=gamma;
Para.P1=P1;
Para.P2=P2;
Para.ApproxMethod=ApproxMethod;
Para.OrderOfApproximationPi=OrderOfApproximationPi;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.VGridDensityFactor=VGridDensityFactor;
Para.PiGridDensityFactor=PiGridDensityFactor;
Para.NIter=NIter;
Para.grelax=grelax;
Para.N=100;
mkdir('Data')
mkdir('Graphs')

CompStr=computer;
switch CompStr

case 'PCWIN64'

BaseDirectory='C:\Users\anmol\Dropbox\ProjectRobustLearning\Matlab\';
SL='\';
case 'GLNX86'

BaseDirectory='/home/anmol/Dropbox/ProjectRobustLearning/Matlab/';
SL='/';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/ProjectRobustLearning/Matlab/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/robust-learning-insurance/Matlab/';

SL='/';
end

CompEconPath=[BaseDirectory 'InfiniteHorizon' SL 'compecon2011' SL 'CEtools' SL];

addpath(genpath(CompEconPath));