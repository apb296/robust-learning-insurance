% Diagnostics
clear all
close all
clc
Exer{1}=['theta_1_finite/Transitory/'];
Exer{2}=['theta_1_finite/Persistent/'];
Exer{3}=['theta_1_infty/Transitory/'];
Exer{4}=['theta_1_infty/Persistent/'];
for ex=1:1
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
pi_ind=1;
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

% BMark
m=1;
alpha=Para.P(1,1,m)+Para.P(1,2,m);
 MPRBM(1)=sqrt(alpha*(1-alpha)) *ra*g ;
m=2;
alpha=Para.P(1,1,m)+Para.P(1,2,m);
 MPRBM(2)=sqrt(alpha*(1-alpha)) *ra*g ;

figure()
subplot(1,2,1)
pi_ind=3;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),'k','LineWidth',2)
hold on
%plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRBM(1)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)
hold on
z=3;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),':k','LineWidth',2)
hold on
%plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRBM(2)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)

xlabel('Agent 2 promised value - v')
ylabel('MPR','Interpreter','Latex')
title('$\pi=1$','Interpreter','Latex')
subplot(1,2,2)
pi_ind=1;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),'k','LineWidth',2)
hold on
%plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRBM(1)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)

hold on

z=3;
plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),squeeze(MPR(z,pi_ind,logical(ExitFlag(z,pi_ind,:)==1))),':k','LineWidth',2)
hold on
%plot(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1)),MPRBM(2)*ones(length(VFineGrid(z,logical(ExitFlag(z,pi_ind,:)==1))),1),'.-k','LineWidth',1)
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

end