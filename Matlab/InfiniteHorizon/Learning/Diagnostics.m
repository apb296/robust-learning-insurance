% Diagnostics
clear all
close all
clc
Exer{1}=['theta_1_finite\Transitory\'];
Exer{2}=['theta_1_finite\persistent\'];
Exer{3}=['theta_1_infty\Transitory\'];
Exer{4}=['theta_1_infty\persistent\'];
for ex=1:4
ThetaPM=Exer{ex}

CompStr=computer;
switch CompStr

case 'PCWIN'

BaseDirectory='C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\';
SL='\';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/Project Robust Learning/Matlab/InfiniteHorizon/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/ProjectRobustLearning/InfiniteHorizon/';

SL='/';
end
CompEconPath=[BaseDirectory 'compecon2011' SL 'CEtools' SL];
PlotPath=[BaseDirectory 'Learning' SL 'Plots' SL ThetaPM];
mkdir(PlotPath)
TexPath=[BaseDirectory 'Learning'  SL 'Tex' SL ThetaPM];
DataPath=[BaseDirectory 'Learning' SL 'Data' SL ThetaPM];
NoLearningPath=[BaseDirectory];
LearningPath=[BaseDirectory 'Learning' SL];
load([ DataPath 'FinalC.mat'])
addpath(genpath(CompEconPath));
Y=Para.Y;
Para.DataPath=DataPath;
Para.PlotPath=PlotPath;
VGrid=Para.VGrid;
PiPlotGrid=[0 .5 1];
VFineGridSize=20;
for z=1:4
    VFineGrid(z,:)=linspace(min(VGrid(z,:)),max(VGrid(z,1:end)),VFineGridSize);
    for pi_ind=1:length(PiPlotGrid)
        pi=PiPlotGrid(pi_ind);
for vind=1:VFineGridSize
xInit=GetInitalPolicyApprox([z pi VFineGrid(z,vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VFineGrid(z,vind),c,Q,Para,xInit);
ExitFlag(z,pi_ind,vind)=resQNew.ExitFlag;
ConsStarRatio(z,pi_ind,vind,:)=(resQNew.ConsStar./(Y))./(resQNew.Cons/(Y(z)));
LambdaStarL(z,pi_ind,vind,:)=resQNew.LambdaStarL;
QNew(vind)=resQNew.Q;
DelVStar(z,pi_ind,vind,:)=resQNew.VStar-VFineGrid(z,vind);
VStar(z,pi_ind,vind,:)=resQNew.VStar-Para.VSuperMax;
EntropyMargAgent1(z,pi_ind,vind)=resQNew.Entropy_Marg_Agent1;
EntropyMargAgent2(z,pi_ind,vind)=resQNew.Entropy_Marg_Agent2;
MPR(z,pi_ind,vind)=resQNew.MPR;
end

    end
end

%% CONSUMPTION PLOTS

% ALPHA[zstar | z,pi,v] / ALPHA[z,pi,v]
% Fig 1 : z=1
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 given $y(z)=y_l$. The solid (dotted) line refers to
% $y(z^*)=y_l (y_h)$. The left (right) panel is the IID Model with $\pi=1$
% ($\pi=0)$
figure()
% PANEL LEFT - IID MODEL
pi_ind=3;
subplot(1,2,1)
zstar=1:2;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
xlabel('v')
ylabel('$\frac{\alpha^*}{\alpha}$','Interpreter','Latex')
hold on
z=1;
zstar=3:4;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\alpha^*}{\alpha}$','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')

% PANEL RIGHT NON IID MODEL
pi_ind=1;
subplot(1,2,2)
zstar=1:2;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
xlabel('v')
ylabel('$\frac{\alpha^*}{\alpha}$','Interpreter','Latex')
hold on
z=1;
zstar=3:4;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\alpha^*}{\alpha}$','Interpreter','Latex')
title('$\pi=0$','Interpreter','Latex')

print(gcf, '-dpng', [ Para.PlotPath 'AlphaStarNoLearning.png'] );

%% FIG 2 - Learning
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 - v keeping y(z^*)=y(z^**) and $\pi=0.5$. The solid (dotted) line refers to
% $s(z^*)=s_l (s_h)$. The left (right) panel is the $y(z)=y_l(y_h)$
pi_ind=2;
%PANEL LEFT -y(z)=y_l
z=1;
figure()
subplot(1,2,1)
zstar=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\alpha^*}{\alpha}$','Interpreter','Latex')
title('$y(z)=y_l$','Interpreter','Latex')
hold on
zstar=2;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
subplot(1,2,2)
pi_ind=2;

%PANEL RIGHT -y(z)=y_h
z=3;
zstar=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
hold on
zstar=2;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(ConsStarRatio(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\alpha^*}{\alpha}$','Interpreter','Latex')
title('$y(z)=y_h$','Interpreter','Latex')

print(gcf, '-dpng', [ Para.PlotPath 'AlphaStarLearning.png'] );

%% ENTROPY 
% Fig 1 - Entropy of Marginals 
% CAPTION : This figure plots the relative entropy of the model averaged
% conditionals for both the agents. The solid (dotted) line refer to Agent 1 (Agent 2).The left (right) panel has y(z)=y_l
% (y_h) and $pi=0.5$ for both the panels
pi_ind=2;
z=1;
figure()
subplot(1,2,1)
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(EntropyMargAgent1(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),'k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('Entropy','Interpreter','Latex')
title('$y(z)=y_l$','Interpreter','Latex')
hold on
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(EntropyMargAgent2(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),':k','LineWidth',2)
z=3;
subplot(1,2,2)
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(EntropyMargAgent1(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),'k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('Entropy','Interpreter','Latex')
title('$y(z)=y_h$','Interpreter','Latex')
hold on
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(EntropyMargAgent2(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),':k','LineWidth',2)

print(gcf, '-dpng', [ Para.PlotPath 'EntropyMarginal.png'] );
% CAPTION : This figure plots the entropy of the marginals as a function of
% Agent 2's promised value- v.  

% Fig 2 - Distorted Priors
% CAPTION : This figure plots the relative distortion of model priors - $\frac{\tilde{\pi}^1}{\tilde{\pi}^2}$
% Agent 2's promised value- v. The left panel has $y(z)=y_l$ and the right.
% panel $y(z)=y_h$

%% MARKET PRICE OF RISK
% CAPTION : This figure plots the MPR as a function of the initial promised
%value to Agent 2- v. The dotted (solid) line refers to y(z)=y_l (y_h). The
%left (right) panel has $\pi=1 (\pi=0)$

%% COMPUTING THE MPR IN THE BENCHMARK CASE
g=.3;
ra=Para.RA;
%IID MODEL

fl=(1-((1+g)/(1-g))^(-ra));
fh=(-1+((1-g)/(1+g))^(-ra));
m=1;
alpha=Para.P(1,1,m)+Para.P(1,2,m);
    MPRIID(1)=(fl*sqrt(alpha*(1-alpha)))/(1-(1-alpha)*fl);
  MPRIID(2)=(fh*sqrt(alpha*(1-alpha)))/(1+(1-alpha)*fh);
  
  
m=2;
alpha=Para.P(1,1,m)+Para.P(1,2,m);
    MPRNonIID(1)=(fl*sqrt(alpha*(1-alpha)))/(1-(1-alpha)*fl);
  MPRNonIID(2)=(fh*sqrt(alpha*(1-alpha)))/(1+(1-alpha)*fh);  

figure()
subplot(1,2,1)
pi_ind=3;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),'k','LineWidth',2)
hold on
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRIID(1)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)
hold on
z=3;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),':k','LineWidth',2)
hold on
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRIID(2)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)


xlabel('Agent 2 promised value - v')
ylabel('MPR','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')
subplot(1,2,2)
pi_ind=1;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),'k','LineWidth',2)
hold on
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRNonIID(1)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)

hold on

z=3;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),':k','LineWidth',2)
hold on
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRNonIID(2)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)
xlabel('Agent 2 promised value - v')
ylabel('MPR','Interpreter','Latex')
title('$\pi=0$','Interpreter','Latex')

print(gcf, '-dpng', [ Para.PlotPath 'MarketPriceOfRiskNoLearning.png'] );

figure()
pi_ind=3;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),'k','LineWidth',2)
hold on
z=3;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),':k','LineWidth',2)
print(gcf, '-dpng', [ Para.PlotPath 'MarketPriceOfRiskLearning.png'] );
%% LAMBDASTAR/LAMBDA
% ALPHA[zstar | z,pi,v] / ALPHA[z,pi,v]
% Fig 1 : z=1
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 given $y(z)=y_l$. The solid (dotted) line refers to
% $y(z^*)=y_l (y_h)$. The left (right) panel is the IID Model with $\pi=1$
% ($\pi=0)$
figure()
% PANEL LEFT - IID MODEL
pi_ind=3;
subplot(1,2,1)
zstar=1:2;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
xlabel('v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
hold on
z=1;
zstar=3:4;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')

% PANEL RIGHT NON IID MODEL
pi_ind=1;
subplot(1,2,2)
zstar=1:2;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
xlabel('v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
hold on
z=1;
zstar=3:4;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
title('$\pi=0$','Interpreter','Latex')

print(gcf, '-dpng', [ Para.PlotPath 'LambdaStarLNoLearning.png'] );

%% FIG 2 - Learning
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 - v keeping y(z^*)=y(z^**) and $\pi=0.5$. The solid (dotted) line refers to
% $s(z^*)=s_l (s_h)$. The left (right) panel is the $y(z)=y_l(y_h)$
pi_ind=2;
%PANEL LEFT -y(z)=y_l
z=1;
figure()
subplot(1,2,1)
zstar=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
title('$y(z)=y_l$','Interpreter','Latex')
hold on
zstar=2;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
subplot(1,2,2)
pi_ind=2;

%PANEL RIGHT -y(z)=y_h
z=3;
zstar=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),'k','LineWidth',2)
hold on
zstar=2;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
title('$y(z)=y_h$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'LambdaStarLLearning.png'] );
%%

Para.N=20000;
BurnSample=.2;
z_draw0=1;
V0=VGrid(z_draw0,3);
pi_bayes0=.5;



%% SIMULATIONS
if Para.P_M(1,2)==0
    disp('Transitory ')
    m_draw0=2;
    disp('simulating Non IID model')
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Para,c,Q,x_state,PolicyRules,BurnSample)
SimDataNonIID=load([Para.DataPath 'SimData.mat']);
save([Para.DataPath 'SimDataNonIID.mat' ],'SimDataNonIID')
%load([Para.DataPath 'SimDataNonIID.mat' ],'SimDataNonIID')
m_draw0=1;
disp('simulatingIID model')
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Para,c,Q,x_state,PolicyRules,BurnSample)
SimDataIID=load([Para.DataPath 'SimData.mat']);
save([Para.DataPath 'SimDataIID.mat' ],'SimDataIID')
%load([Para.DataPath 'SimDataIID.mat' ],'SimDataIID')
% Steady State distributions

figure()
subplot(1,2,2)
hist(SimDataNonIID.V(Para.N*BurnSample:Para.N),100)
xlabel('v')
title('$\pi=0$','Interpreter','Latex')
subplot(1,2,1)
hist(SimDataIID.V(Para.N*BurnSample:Para.N),100)
xlabel('v')
title('$\pi=1$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'VSS.png'] );
figure()
subplot(1,2,2)
hist(SimDataNonIID.Lambda_draw(Para.N*BurnSample:Para.N-1),100)
xlabel('$\lambda$','Interpreter','Latex')
title('$\pi=0$','Interpreter','Latex')

subplot(1,2,1)
hist(SimDataIID.Lambda_draw(Para.N*BurnSample:Para.N-1),100)
xlabel('$\lambda$','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')

print(gcf, '-dpng', [ Para.PlotPath 'LambdaSS.png'] );
figure()
subplot(1,2,2)
hist(SimDataNonIID.MPR_draw(Para.N*BurnSample:Para.N-1),100)
xlabel('MPR','Interpreter','Latex')
title('$\pi=0$','Interpreter','Latex')

subplot(1,2,1)
hist(SimDataIID.MPR_draw(Para.N*BurnSample:Para.N-1),100)
xlabel('MPR','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'MPRSS.png'] );
figure()
hist(SimDataNonIID.pi_bayes(Para.N*BurnSample:Para.N),100)
print(gcf, '-dpng', [ Para.PlotPath 'PiBayesSS.png'] );
figure()
hist(SimDataNonIID.pi_dist1(Para.N*BurnSample:Para.N),100)
print(gcf, '-dpng', [ Para.PlotPath 'PiDist1SS.png'] );
figure()
hist(SimDataNonIID.pi_dist2(Para.N*BurnSample:Para.N),100)
print(gcf, '-dpng', [ Para.PlotPath 'PiDist2SS.png'] );
  
% sample draws
T=100;
SimDataNonIID.z_drawTrunc=SimDataNonIID.z_draw(end-T+1:end);
SimDataNonIID.VTrunc=SimDataNonIID.V(end-T+1:end);
SimDataNonIID.Lambda_drawTrunc=SimDataNonIID.Lambda_draw(end-T+1:end);
SimDataNonIID.MPR_drawTrunc=SimDataNonIID.MPR_draw(end-T+1:end);
SimDataNonIID.pi_bayesTrunc=SimDataNonIID.pi_bayes(end-T+1:end);
SimDataNonIID.pi_dist1=SimDataNonIID.pi_dist1(end-T+1:end);
SimDataNonIID.pi_dist2=SimDataNonIID.pi_dist2(end-T+1:end);

InxNonIID=find(SimDataNonIID.z_drawTrunc<3);
    for i=1:length(InxNonIID)-1
        bbNonIID{i}=InxNonIID(i):InxNonIID(i+1);
    end


SimDataIID.z_drawTrunc=SimDataIID.z_draw(end-T+1:end);
SimDataIID.VTrunc=SimDataIID.V(end-T+1:end);
SimDataIID.Lambda_drawTrunc=SimDataIID.Lambda_draw(end-T+1:end);
SimDataIID.MPR_drawTrunc=SimDataIID.MPR_draw(end-T+1:end);
SimDataIID.pi_bayesTrunc=SimDataIID.pi_bayes(end-T+1:end);
SimDataIID.pi_dist1=SimDataIID.pi_dist1(end-T+1:end);
SimDataIID.pi_dist2=SimDataIID.pi_dist2(end-T+1:end);




InxIID=find(SimDataIID.z_drawTrunc<3);
    for i=1:length(InxIID)-1
        bbIID{i}=InxIID(i):InxIID(i+1);
    end
figure()
subplot(2,1,2)
plot(SimDataNonIID.MPR_drawTrunc)
axis([1 T min(SimDataNonIID.MPR_drawTrunc)*.9 max(SimDataNonIID.MPR_drawTrunc)*1.1])
ShadePlotForEmpahsis( bbNonIID,'r',.05);
  ylabel('MPR','Interpreter','Latex')
title('$\pi=0$','Interpreter','Latex')

  subplot(2,1,1)
plot(SimDataIID.MPR_drawTrunc)
axis([1 T min(SimDataIID.MPR_drawTrunc)*.9 max(SimDataIID.MPR_drawTrunc)*1.1])
  ShadePlotForEmpahsis( bbIID,'r',.05);
    ylabel('MPR','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')

print(gcf, '-dpng', [ Para.PlotPath 'MPRDraw.png'] );
else
    
m_draw0=1;
disp('Persistent')
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Para,c,Q,x_state,PolicyRules,BurnSample)
SimData=load([Para.DataPath 'SimData.mat']);

% Steady State distributions

figure()
hist(SimData.V(Para.N*BurnSample:Para.N),100)
xlabel('v')
print(gcf, '-dpng', [ Para.PlotPath 'VSS.png'] );
figure()
hist(SimData.Lambda_draw(Para.N*BurnSample:Para.N-1),100)
xlabel('$\lambda$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'LambdaSS.png'] );
figure()
hist(SimData.MPR_draw(Para.N*BurnSample:Para.N-1),100)
xlabel('MPR')
print(gcf, '-dpng', [ Para.PlotPath 'MPRSS.png'] );
figure()
hist(SimData.pi_bayes(Para.N*BurnSample:Para.N),100)
xlabel('$\pi$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'PiBayesSS.png'] );
figure()
hist(SimData.pi_dist1(Para.N*BurnSample:Para.N),100)
xlabel('$\tilde{\pi}_1$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'PiDist1SS.png'] );
figure()
hist(SimData.pi_dist2(Para.N*BurnSample:Para.N),100)
xlabel('$\tilde{\pi}_2$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'PiDist2SS.png'] );
figure()
hist((SimData.pi_dist1(Para.N*BurnSample:Para.N)./SimData.pi_dist2(Para.N*BurnSample:Para.N)),100)
xlabel('$\frac{\tilde{\pi}_1}{\tilde{\pi}_2}$','Interpreter','Latex')
print(gcf, '-dpng', [ Para.PlotPath 'RelPiDistSS.png'] );


% sample draws
T=100;
SimData.z_drawTrunc=SimData.z_draw(end-T+1:end);
SimData.VTrunc=SimData.V(end-T+1:end);
SimData.Lambda_drawTrunc=SimData.Lambda_draw(end-T+1:end);
SimData.MPR_drawTrunc=SimData.MPR_draw(end-T+1:end);
SimData.pi_bayesTrunc=SimData.pi_bayes(end-T+1:end);
SimData.pi_dist1Trunc=SimData.pi_dist1(end-T+1:end);
SimData.pi_dist2Trunc=SimData.pi_dist2(end-T+1:end);
Inx=find(SimData.z_drawTrunc<3);
    for i=1:length(Inx)-1
        bb{i}=Inx(i):Inx(i+1);
    end
figure()
plot(SimData.MPR_drawTrunc)
axis([1 T min(SimData.MPR_drawTrunc)*.9 max(SimData.MPR_drawTrunc)*1.1])
  ShadePlotForEmpahsis( bb,'r',.05);
  xlabel('time')  
  ylabel('MPR')
   print(gcf, '-dpng', [ Para.PlotPath 'MPRDraw.png'] );
end
end
DiagnosticsMPR
%% test area
z=1
pi=.5
vind=2
VGrid=Para.VGrid;
xInit=GetInitalPolicyApprox([z pi VGrid(z,vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VGrid(z,vind),c,Q,Para,xInit);
resQNew.PricingKernel
resQNew.Zeta
MaxMinRatio=max(resQNew.PricingKernel)/min(resQNew.PricingKernel)

