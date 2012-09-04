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

BaseDirectory='C:\Users\anmol\Dropbox\ProjectRobustLearning\Matlab\InfiniteHorizon\';
SL='\';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/ProjectRobustLearning/Matlab/InfiniteHorizon/';
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
PiPlotGrid=linspace(.01,.99,20);
VFineGridSize=20;
for z=1:4
    VFineGrid(z,:)=linspace(min(VGrid(z,:)),max(VGrid(z,1:end)),VFineGridSize);
    for pi_ind=1:length(PiPlotGrid)
 alphabar=(Para.P(1,1,1)+Para.P(1,2,1))*PiPlotGrid(pi_ind)+(1-PiPlotGrid(pi_ind))*(Para.P(1,1,2)+Para.P(1,2,2));

        MPREU(pi_ind,:)=EU_MPR(alphabar,Para.RA,.3);
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
pi_tilde_agent1(z,pi_ind,vind)=resQNew.DistPi_agent1;
pi_tilde_agent2(z,pi_ind,vind)=resQNew.DistPi_agent2;
end

    end
end

% FIGURE : MPRLEARNINGPI
% CAPTION : This figure plots the conditional market price of risk as
% function of $\pi$. The solid (dotted) line is y(z)=y_l (y_h). The left
% panel has $\theta_2<\infty,\theta_1=\infty $ and the right panel has both
% $\theta_1,\theta_2=\infty$
figure()
subplot(1,2,1)
v_ind=20;
z=1;
plot(PiPlotGrid',squeeze(MPR(z,:,v_ind))','k','LineWidth',2)
hold on
z=3;
plot(PiPlotGrid',squeeze(MPR(z,:,v_ind))',':k','LineWidth',2)
xlabel('$\pi$','Interpreter','Latex')
ylabel('MPR')
title('$\theta_2 <\infty,\theta_1=\infty$','Interpreter','Latex')
subplot(1,2,2)

plot(PiPlotGrid',MPREU(:,1),'k','LineWidth',2)
hold on
plot(PiPlotGrid',MPREU(:,2),':k','LineWidth',2)
xlabel('$\pi$','Interpreter','Latex')
ylabel('MPR')
title('$\theta_2 =\infty,\theta_1=\infty$','Interpreter','Latex')
  print(gcf, '-dpng', [ Para.PlotPath 'MPRLearningPi.png'] );

figure()
z=1;
surf(PiPlotGrid',VFineGrid(z,:)',squeeze(MPR(z,:,:))')
hold on
z=3;
surf(PiPlotGrid',VFineGrid(z,:)',squeeze(MPR(z,:,:))')
hold on




%FIGURE : DISTORTED MODEL PRIORS
%\caption{This figure plots the $\frac{\tilde{\pi}^2}{\tilde{pi}^1}$ as a function of $v,\pi$. The left (right) panel has $y(z)=y_l (y_h)$     
figure()
    subplot(1,2,1)
    z=1
    surf(PiPlotGrid',VFineGrid(z,:)',squeeze(pi_tilde_agent2(z,:,:))'./squeeze(pi_tilde_agent1(z,:,:))')
    xlabel('$\pi$','Interpreter','Latex')
    ylabel('v')
    %zlabel('$\frac{\tilde{pi}^2}{\tilde{pi}^1}$','Interpreter','Latex')
    subplot(1,2,2)
    z=3
    surf(PiPlotGrid',VFineGrid(z,:)',squeeze(pi_tilde_agent2(z,:,:))'./squeeze(pi_tilde_agent1(z,:,:))')
    xlabel('$\pi$','Interpreter','Latex')
    ylabel('v')
    %zlabel('$\frac{\tilde{pi}^2}{\tilde{pi}^1}$','Interpreter','Latex')
    print(gcf, '-dpng', [ Para.PlotPath 'DistortedPriors.png'] );
end
%% test area
z=1;
pi=.6;
vind=20;
VGrid=Para.VGrid;
xInit=GetInitalPolicyApprox([z pi VGrid(z,vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VGrid(z,vind),c,Q,Para,xInit);
resQNew.Zeta
resQNew.ConsStarRatio
testMPR(z)=resQNew.MPR;

z=3;
pi=.6;
vind=20;
VGrid=Para.VGrid;
xInit=GetInitalPolicyApprox([z pi VGrid(z,vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VGrid(z,vind),c,Q,Para,xInit);
testMPR(z)=resQNew.MPR;
resQNew.Zeta
resQNew.ConsStarRatio
testMPR(1)/testMPR(3)


