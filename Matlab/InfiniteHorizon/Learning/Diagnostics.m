% Diagnostics
clear all
close all
clc
Exer{1}=['theta_1_finite/Transitory/'];
Exer{2}=['theta_1_finite/Persistent/'];
Exer{3}=['theta_1_infty/Transitory/'];
Exer{4}=['theta_1_infty/Persistent/'];
for ex=4:4
ThetaPM=Exer{ex}
CompStr=computer;
switch CompStr

case 'PCWIN64'

BaseDirectory='C:\Users\anmol\Dropbox\ProjectRobustLearning\Matlab\InfiniteHorizon\';
SL='\';
case 'GLNX86'

BaseDirectory='/home/anmol/Dropbox/ProjectRobustLearning/Matlab/InfiniteHorizon/';
SL='/';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/ProjectRobustLearning/Matlab/InfiniteHorizon/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/robust-learning-insurance/Matlab/InfiniteHorizon/';

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
ExitFlag(z,pi_ind,vind)=resQNew.ExitFlag*( max(resQNew.VStar-max(Para.VGrid,[],2)')<0);
ConsStarRatio(z,pi_ind,vind,:)=(resQNew.ConsStar./(Y))./(resQNew.Cons/(Y(z)));
Lambda(z,pi_ind,vind)=resQNew.Lambda;
LambdaStarL(z,pi_ind,vind,:)=resQNew.LambdaStarL;
QNew(vind)=resQNew.Q;
DelVStar(z,pi_ind,vind,:)=resQNew.VStar-VFineGrid(z,vind);
VStar(z,pi_ind,vind,:)=resQNew.VStar;
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
  MPRNonIID(2)=(fh*sqrt(alpha*(1-alpha)))/(1+(1-alpha)*fh)

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


% Lambdastar growth rate
pi_ind=2;
%PANEL LEFT -y(z)=y_l
z=1;
figure()
zstar=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),1:4)),'k','LineWidth',1)
hold on
z=3
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),1:4)),':k','LineWidth',1)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')




% Lambdastar growth rate
pi_ind=2;
%PANEL LEFT -y(z)=y_l
z=1;
figure()
zstar=1;
plot(Lambda(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),1:4)),'k','LineWidth',1)
hold on
z=3
plot(Lambda(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(LambdaStarL(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1),1:4)),':k','LineWidth',1)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')


BurnSample=0.5
%% SIMULATIONS
if Para.P_M(1,2)==0
SimDataIID=load ([DataPath 'SimDataIID.mat']);
SimDataNonIID=load ([DataPath  'SimDataNonIID.mat']);
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
SimDataNonIID.z_drawTrunc=SimDataNonIID.z_draw(1:T);
SimDataNonIID.VTrunc=SimDataNonIID.V(1:T);
SimDataNonIID.Lambda_drawTrunc=SimDataNonIID.Lambda_draw(1:T);
SimDataNonIID.MPR_drawTrunc=SimDataNonIID.MPR_draw(1:T);
SimDataNonIID.pi_bayesTrunc=SimDataNonIID.pi_bayes(1:T);
SimDataNonIID.pi_dist1=SimDataNonIID.pi_dist1(1:T);
SimDataNonIID.pi_dist2=SimDataNonIID.pi_dist2(1:T);

InxNonIID=find(SimDataNonIID.z_drawTrunc<3);
    for i=1:length(InxNonIID)-1
        bbNonIID{i}=InxNonIID(i):InxNonIID(i+1);
    end


SimDataIID.z_drawTrunc=SimDataIID.z_draw(1:T);
SimDataIID.VTrunc=SimDataIID.V(1:T);
SimDataIID.Lambda_drawTrunc=SimDataIID.Lambda_draw(1:T);
SimDataIID.MPR_drawTrunc=SimDataIID.MPR_draw(1:T);
SimDataIID.pi_bayesTrunc=SimDataIID.pi_bayes(1:T);
SimDataIID.pi_dist1=SimDataIID.pi_dist1(1:T);
SimDataIID.pi_dist2=SimDataIID.pi_dist2(1:T);




InxIID=find(SimDataIID.z_drawTrunc<3);
    for i=1:length(InxIID)-1
        bbIID{i}=InxIID(i):InxIID(i+1);
    end
figure()
subplot(2,1,2)
plot(SimDataNonIID.MPR_drawTrunc)
%axis([1 T min(SimDataNonIID.MPR_drawTrunc)*.9 max(SimDataNonIID.MPR_drawTrunc)*1.1])
ShadePlotForEmpahsis( bbNonIID,'r',.05);
  ylabel('MPR','Interpreter','Latex')
title('$\pi=0$','Interpreter','Latex')

  subplot(2,1,1)
plot(SimDataIID.MPR_drawTrunc)
%axis([1 T min(SimDataIID.MPR_drawTrunc)*.9 max(SimDataIID.MPR_drawTrunc)*1.1])
  ShadePlotForEmpahsis( bbIID,'r',.05);
    ylabel('MPR','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')

print(gcf, '-dpng', [ Para.PlotPath 'MPRDraw.png'] );
else
    SimData=load ([DataPath 'SimData.mat']);
    

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
SimData.z_drawTrunc=SimData.z_draw(1:T);
SimData.VTrunc=SimData.V(1:T);
SimData.Lambda_drawTrunc=SimData.Lambda_draw(1:T);
SimData.MPR_drawTrunc=SimData.MPR_draw(1:T);
SimData.pi_bayesTrunc=SimData.pi_bayes(1:T);
SimData.pi_dist1Trunc=SimData.pi_dist1(1:T);
SimData.pi_dist2Trunc=SimData.pi_dist2(1:T);
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
%DiagnosticsMPR
%% test area
z=1
pi=0.9
v=4.9031
xInit=GetInitalPolicyApprox([z pi v],SolData.x_state,SolData.PolicyRules);
xInit=xInit*(1+.1*rand)
resQNew=getQNew(z,pi,v,SolData.c,SolData.Q,SolData.Para,xInit);

VGrid=Para.VGrid;
xInit=GetInitalPolicyApprox([z pi VGrid(z,vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VGrid(z,vind),c,Q,Para,xInit);
resQNew.PricingKernel
resQNew.Zeta
MaxMinRatio=max(resQNew.PricingKernel)/min(resQNew.PricingKernel)
clear all
SolData=load ('Data/Theta_1_finite/Persistent/FinalC.mat');
P=SolData.Para.P;
theta1=SolData.Para.Theta(1,1);
theta2=SolData.Para.Theta(1,2);
Y=SolData.Para.Y;
ra=SolData.Para.RA;
delta=SolData.Para.delta;
P_M=SolData.Para.P_M;
z=1;
pi=.1;
vbar=fsolve(@(v) ResVBar(v,z,pi,SolData), [mean(SolData.Para.VGrid(z,:))])
xInit=GetInitalPolicyApprox([z pi vbar],SolData.x_state,SolData.PolicyRules);
resQNew=getQNew(z,pi,vbar,SolData.c,SolData.Q,SolData.Para,xInit);
resQNew.Lambda
resQNew.LambdaStar

%startionary value function with alpha =0.5
[Coeff_alphamin,Q_alphamin]=ComputeRU_alpha(0.5,SolData.Para,linspace(0,1,20),1,25);
% stattionary values 

            pi_m=[pi 1-pi];  % vector pi
            
            % Applying Bayes Law given P,P_M and pi
            for zstar=1:4
                
                % Updating the filter using bayes law (checked the code with
                % HMMFilter.m)
                for m_star_indx=1:2
                    Num=0;
                    for m_indx=1:2
                        Num=Num+P(z,zstar,m_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx);
                    end
                    pi_m(m_star_indx)= Num;
                end
                D=sum(pi_m(:));
                pi_m_star= pi_m(:)/D;
                pistar(zstar)=pi_m_star(1);
                
            end
            
for zInd=1:4
vbarGuess(zInd)=funeval(Coeff_alphamin(zInd,:)',Q_alphamin(zInd),pistar(zInd));
end
% Do these satisfy the PK constraint
   for m=1:2
                T1(m)=u(0.5*Y(z),ra)-theta1*delta*log(sum(P(z,:,m).*exp(-vbarGuess/theta1)))   ;
            end
            
            % Apply T2 operator
            T2=-theta2*log(exp(-T1/theta2)*([pi; 1-pi]));
           
            
funeval(Coeff_alphamin(z,:)',Q_alphamin(z),pi)-T2
funeval(Coeff_alphamin(z,:)',Q_alphamin(z),pi)-funeval(SolData.c(z,:)' ,SolData.Q(z), [pi T2])


resQNew=getQNew(z,pi,T2,SolData.c,SolData.Q,SolData.Para,[0.5*SolData.Para.Y(z) vbarGuess]);
funeval(SolData.c(z,:)' ,SolData.Q(z), [pi T2])-resQNew.Q
funeval(Coeff_alphamin(z,:)',Q_alphamin(z),pi)-resQNew.Q


[resQNew.VStar;vbarGuess]

for zInd=1:4
vbarGuess(zInd)=fsolve(@(v) ResVBar(v,zInd,resQNew.pistar(zInd),SolData), [mean(SolData.Para.VGrid(zInd,:))])
end

resQNew=getQNew(z,pi,vbar,SolData.c,SolData.Q,SolData.Para,[0.5*SolData.Para.Y(z) vbarGuess]);
resQNew.Lambda+funeval(SolData.c(z,:)' ,SolData.Q(z), [pi vbar],[0 1])
resQNew.Q-funeval(SolData.c(z,:)' ,SolData.Q(z), [pi vbar])

resQNew.ConsStar./SolData.Para.Y
resQNew.DistP_agent1
resQNew.DistP_agent2
