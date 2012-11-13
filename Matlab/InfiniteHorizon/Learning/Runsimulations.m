% Diagnostics
clear all
close all
clc
err=[];
try
    
    matlabpool size
    
catch err
end
if isempty(err)
    
    
    if(matlabpool('size') > 0)
        matlabpool close force local
    end
    
    matlabpool open local;
    
end

Exer{1}=['theta_1_finite/Transitory/'];
Exer{2}=['theta_1_finite/Persistent/'];
Exer{3}=['theta_1_infty/Transitory/'];
Exer{4}=['theta_1_infty/Persistent/'];
N=50000;

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
CompEconPath=[ BaseDirectory 'compecon2011' SL 'CEtools' SL];

addpath(genpath(CompEconPath));

for ex=1:4
ThetaPM=Exer{ex};
DataPath=['Data/' ThetaPM];
SolData(ex)=load([DataPath 'FinalC.mat']);
Param(ex)=SolData.Para;
Param(ex).N=N;
end
parfor ex=1:4
ThetaPM=Exer{ex};
DataPath=['Data' SL ThetaPM];
BurnSample=.2;
z_draw0=1;
V0=Param(ex).VGrid(z_draw0,3);
pi_bayes0=.5;



%% SIMULATIONS
if Param(ex).P_M(1,2)==0
    disp('Transitory ')
    m_draw0=2;
    flagTransitoryIID=0;
    disp('simulating Non IID model')
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Param(ex),SolData(ex).c,SolData(ex).Q,SolData(ex).x_state,SolData(ex).PolicyRules,DataPath,flagTransitoryIID)
m_draw0=1;
   flagTransitoryIID=1;
disp('simulatingIID model')
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Param(ex),SolData(ex).c,SolData(ex).Q,SolData(ex).x_state,SolData(ex).PolicyRules,DataPath,flagTransitoryIID)
else
m_draw0=1;
disp('Persistent')
   flagTransitoryIID=-1;
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Param(ex),SolData(ex).c,SolData(ex).Q,SolData(ex).x_state,SolData(ex).PolicyRules,DataPath,flagTransitoryIID)% Steady State distributions
end
end
