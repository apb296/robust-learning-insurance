clear all
% This file generates the plots for simulated paths across settings with a
% common sequence of shocks
Exer{1}=['theta_1_finite/Transitory/'];
Exer{2}=['theta_1_finite/Persistent/'];
Exer{3}=['theta_1_infty/Transitory/'];
Exer{4}=['theta_1_infty/Persistent/'];

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


T=500; %Length of the simulation

N=100; %Number of  simulations


ex0=2;
z_draw0=1;
m_draw0=1;
pi_bayes0=.5;
ConsRatioLow=0.75;

for kk=1:2
ex=ex0+(kk-1)*2;


DataPath=['Data/' Exer{ex}]
InitData=load([DataPath 'FinalC.mat'])

Indx_z=find(InitData.x_state(:,1)==z_draw0);
[val,indx]=min(abs((InitData.PolicyRules(Indx_z,1)./InitData.Para.Y(InitData.x_state(Indx_z,1)))-ConsRatioLow));
VSlice=InitData.x_state(Indx_z,3);
VGuess=VSlice(indx)
V0=fzero(@(v) GetValueFromTargetConsumption(v,z_draw0,pi_bayes0,ConsRatioLow,InitData),VGuess);
z_draw=zeros(N,1);
m_draw=zeros(N,1);
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
flagTransitoryIID=-2;

res(kk)=SimulateV(m_draw0,z_draw0,V0,pi_bayes0,InitData.Para,InitData.c,InitData.Q,InitData.x_state,InitData.PolicyRules,DataPath,flagTransitoryIID,Shocks);
end








InxShade=find(res(1).z_draw<3);
    for i=1:length(InxShade)-1
        bb{i}=InxShade(i):InxShade(i+1);
    end
figure()
plot(res(1).ConsShareAgent1,'k','LineWidth',2)
hold on
plot(res(2).ConsShareAgent1,':k','LineWidth',2)

%axis([1 T min(SimDataNonIID.MPR_drawTrunc)*.9 max(SimDataNonIID.MPR_drawTrunc)*1.1])
ShadePlotForEmpahsis( bb,'r',.05);
  


figure()
plot(res(1).Lambda_draw,'k','LineWidth',2)
hold on
plot(res(2).Lambda_draw,':k','LineWidth',2)

%axis([1 T min(SimDataNonIID.MPR_drawTrunc)*.9 max(SimDataNonIID.MPR_drawTrunc)*1.1])
ShadePlotForEmpahsis( bb,'r',.05);
  
