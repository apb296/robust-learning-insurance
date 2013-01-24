clear all
clc
close all
% This file generates the plots for simulated paths across settings with a
% common sequence of shocks
Exer{1}=['theta_1_finite/Transitory/'];
Exer{2}=['theta_1_finite/Persistent/'];
Exer{3}=['theta_1_infty/Transitory/'];
Exer{4}=['theta_1_infty/Persistent/'];
Exer{5}=['theta_2_infty/Transitory/'];
Exer{6}=['theta_2_infty/Persistent/'];

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
T=250; %Length of the simulation

disp('create the simulationdata structure and draw the shocks')
tic
ctrb=1;
for ex0=1:2
    for m_draw0=1:2
z_draw0=1;
pi_bayes0=.5;
if m_draw0==1
pi_bayes0=1;
else
pi_bayes0=0;
end
ConsRatioLow=0.75;

for kk=1:3
ex=ex0+(kk-1)*2;
DataPath=['Data/' Exer{ex}];
InitData=load([DataPath 'FinalC.mat']);
Indx_z=find(InitData.x_state(:,1)==z_draw0);
[val,indx]=min(abs((InitData.PolicyRules(Indx_z,1)./InitData.Para.Y(InitData.x_state(Indx_z,1)))-ConsRatioLow));
VSlice=InitData.x_state(Indx_z,3);
VGuess=VSlice(indx);
V0=fzero(@(v) GetValueFromTargetConsumption(v,z_draw0,pi_bayes0,ConsRatioLow,InitData),VGuess);
z_draw=zeros(T,1);
m_draw=zeros(T,1);
z_draw(1)=z_draw0;
m_draw(1)=m_draw0;
InitData.Para.N=T;
if kk==1
for i=2:InitData.Para.N
  
    m_dist=InitData.Para.P_M(m_draw(i-1),:);
    m_draw(i)=discretesample(m_dist, 1);
    z_dist=InitData.Para.P(z_draw(i-1),:,m_draw(i-1));
    z_draw(i)=discretesample(z_dist, 1);
end
Shocks.z_draw=z_draw;
Shocks.m_draw=z_draw;
end

SimulationData(ctrb).PermenantLearning=ex0-1;
SimulationData(ctrb).m_draw0=m_draw0;
SimulationData(ctrb).z_draw0=z_draw0;
SimulationData(ctrb).V0=V0;
SimulationData(ctrb).Para=InitData.Para;
SimulationData(ctrb).pi_bayes0=pi_bayes0;
SimulationData(ctrb).c=InitData.c;
SimulationData(ctrb).Q=InitData.Q;
SimulationData(ctrb).x_state=InitData.x_state;
SimulationData(ctrb).PolicyRules=InitData.PolicyRules;
SimulationData(ctrb).DataPath=DataPath;
SimulationData(ctrb).flagTransitoryIID=-2;
SimulationData(ctrb).Shocks=Shocks;
ctrb=ctrb+1;
end

    end
    


end


toc
% -- SET UP THE PARALLEL CONFIGURATION ----------------------------------
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

tic
% ------------------------------------------------------------------------

parfor ctrb=1:length(SimulationData)
  res(ctrb)=SimulateV(SimulationData(ctrb).m_draw0,...
      SimulationData(ctrb).z_draw0,SimulationData(ctrb).V0,...
      SimulationData(ctrb).pi_bayes0,SimulationData(ctrb).Para,...
      SimulationData(ctrb).c,SimulationData(ctrb).Q,...
      SimulationData(ctrb).x_state,SimulationData(ctrb).PolicyRules...
      ,SimulationData(ctrb).DataPath,...
      SimulationData(ctrb).flagTransitoryIID,SimulationData(ctrb).Shocks);
end
toc
save( ['Data/SimulationData.mat'],'SimulationData','res');















