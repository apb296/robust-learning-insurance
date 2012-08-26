% This program compares the solution to the case with learning and pi=0 or
% 1 with the solution to the case without learning.
close all
clc
clear all

CompStr=computer;
switch CompStr

case 'PCWIN'

BaseDirectory='C:\Users\anmol\Dropbox\ProjectRobustLearning\Matlab\InfiniteHorizon\';
SL='\';
case 'GLNX86'

BaseDirectory='/home/anmol/Dropbox/ProjectRobustLearning/Matlab/InfiniteHorizon/';
SL='/';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/ProjectRobustLearning/Matlab/InfiniteHorizon/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/ProjectRobustLearning/InfiniteHorizon/';

SL='/';
end

CompEconPath=[BaseDirectory 'compecon2011' SL 'CEtools' SL];
PlotPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Plots' SL];
TexPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Tex' SL];
DataPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Data' SL];
NoLearningPath=[BaseDirectory];
LearningPath=[BaseDirectory 'Learning' SL];



addpath(genpath(CompEconPath));

Para.m=2;
CoeffFileName=['CoeffRU_NL_' int2str(Para.m) '.mat'];
ParaFileName=['Para_NL_' int2str(Para.m) '.mat'];
FSpaceFileName=['QNL_' int2str(Para.m) '.mat'];
load([ BaseDirectory 'Data/' CoeffFileName])
load(['Data/' FSpaceFileName])
load(['Data/' ParaFileName]);


VGrid=Para.VGrid;
c(1,:)=coeff(1,:);
c(2,:)=coeff(1,:);
c(3,:)=coeff(2,:);
c(4,:)=coeff(2,:);
for z=1:Para.ZSize
    tic
    x0=[];

    for v=1:Para.VGridSize
        resQNew=getQNew(z,VGrid(z,v),c,Q,Para,x0);
        QNew(z,v)=resQNew.Q;
        LambdaStarL(z,v,:)=resQNew.LambdaStarL;
        Lambda(z,v)=resQNew.Lambda;
        MRS(z,v,:)=resQNew.MRS;
        MPR(z,v)=resQNew.MPR;
           RelMPR(z,v)=resQNew.RelMPR;
        EntropyMargAgent1(z,v)=resQNew.Entropy_Marg_Agent1;
EntropyMargAgent2(z,v)=resQNew.Entropy_Marg_Agent2;
         Cons(z,v)=resQNew.Cons;
         ConsStarRatio(z,v,:)=resQNew.ConsStarRatio;
         ConsStar(z,v,:)=resQNew.ConsStar;
         ExitFlag(z,v)=resQNew.ExitFlag;
                VStar(z,v,:)=resQNew.VStar;
                DelVStar(z,v,:)=resQNew.VStar-VGrid(z,v);
        x0=[Cons(z,v) VStar(z,v,1) VStar(z,v,3)];
       

    end
 
end
VFineGrid=VGrid;
% Fig 1 : z=1
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 given $y(z)=y_l$. The solid (dotted) line refers to
% $y(z^*)=y_l (y_h)$. 
figure()
zstar=1:2;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(ConsStarRatio(z,logical(ExitFlag(z,:)==1),zstar)),'k','LineWidth',2)
xlabel('v')
ylabel('$\frac{\alpha^*[y_h]}{\alpha}$','Interpreter','Latex')
hold on
z=1;
zstar=3:4;
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(ConsStarRatio(z,logical(ExitFlag(z,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\alpha^*[y_h]}{\alpha}$','Interpreter','Latex')
%title('$\pi=1$','Interpreter','Latex')


%% ENTROPY 
% Fig 1 - Entropy of Marginals 
% CAPTION : This figure plots the entropy of the marginals as a function of
% Agent 2's promised value- v. The solid (dotted) line refer to Agent 1 (Agent 2) 
z=1;
figure()
subplot(1,2,1)
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(EntropyMargAgent1(z,logical(ExitFlag(z,:)==1))),'k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('Entropy','Interpreter','Latex')
title('$y(z)=y_l$','Interpreter','Latex')
hold on
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(EntropyMargAgent2(z,logical(ExitFlag(z,:)==1))),':k','LineWidth',2)
z=3
subplot(1,2,2)
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(EntropyMargAgent1(z,logical(ExitFlag(z,:)==1))),'k','LineWidth',2)
hold on
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(EntropyMargAgent2(z,logical(ExitFlag(z,:)==1))),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('Entropy','Interpreter','Latex')
title('$y(z)=y_h$','Interpreter','Latex')

% Fig 2 - Distorted Priors
% CAPTION : This figure plots the relative distortion of model priors - $\frac{\tilde{\pi}^1}{\tilde{\pi}^2}$
% Agent 2's promised value- v. The left panel has $y(z)=y_l$ and the right.
% panel $y(z)=y_h$

%% MARKET PRICE OF RISK
figure()
z=1
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(MPR(z,logical(ExitFlag(z,:)==1))),'k','LineWidth',2)
hold on
z=3
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(MPR(z,logical(ExitFlag(z,:)==1))),':k','LineWidth',2)


%% MARKET PRICE OF RISK
figure()
z=1
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(MPR(z,logical(ExitFlag(z,:)==1))),'k','LineWidth',2)
hold on
z=3
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(MPR(z,logical(ExitFlag(z,:)==1))),':k','LineWidth',2)


%% MARKET PRICE OF RISK with Lambda
figure()
z=1
plot(Lambda(z,logical(ExitFlag(z,:)==1)),squeeze(RelMPR(z,logical(ExitFlag(z,:)==1))),'k','LineWidth',2)
hold on
z=3
plot(Lambda(z,logical(ExitFlag(z,:)==1)),squeeze(RelMPR(z,logical(ExitFlag(z,:)==1))),':k','LineWidth',2)



%% LAMBDASTAR/LAMBDA
% ALPHA[zstar | z,pi,v] / ALPHA[z,pi,v]
% Fig 1 : z=1
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 given $y(z)=y_l$. The solid (dotted) line refers to
% $y(z^*)=y_l (y_h)$. The left (right) panel is the IID Model with $\pi=1$
% ($\pi=0)$
figure()
% PANEL LEFT - IID MODEL
zstar=1:2;
z=1;
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(LambdaStarL(z,logical(ExitFlag(z,:)==1),zstar)),'k','LineWidth',2)
xlabel('v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
hold on
z=1;
zstar=3:4;
plot(VFineGrid(z,logical(ExitFlag(z,:)==1)),squeeze(LambdaStarL(z,logical(ExitFlag(z,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')



%% LAMBDASTAR/LAMBDA
% ALPHA[zstar | z,pi,v] / ALPHA[z,pi,v]
% Fig 1 : z=1
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 given $y(z)=y_l$. The solid (dotted) line refers to
% $y(z^*)=y_l (y_h)$. The left (right) panel is the IID Model with $\pi=1$
% ($\pi=0)$
figure()
% PANEL LEFT - IID MODEL
zstar=1:2;
z=1;
plot(Lambda(z,logical(ExitFlag(z,:)==1)),squeeze(LambdaStarL(z,logical(ExitFlag(z,:)==1),zstar)),'k','LineWidth',2)
xlabel('v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')
hold on
z=1;
zstar=3:4;
plot(Lambda(z,logical(ExitFlag(z,:)==1)),squeeze(LambdaStarL(z,logical(ExitFlag(z,:)==1),zstar)),':k','LineWidth',2)
xlabel('Agent 2 promised value - v')
ylabel('$\frac{\lambda^*}{\lambda}$','Interpreter','Latex')


%% SIMULATIONS
















figure()
fplot(@(v) funeval(c(z,:)',Q(z),v),[min(VGrid(z,:)),max(VGrid(z,:))]')
figure()
plot(VGrid(z,logical(squeeze(ExitFlag(z,:))==1))' ,squeeze(QNew(z,logical(squeeze(ExitFlag(z,:))==1),1)))
% figure()
% %plot(squeeze(LambdaStarL(1,:,1))')
% %Data=[squeeze(LambdaStarL(1,:,1))' squeeze(LambdaStarL(1,:,2))'  squeeze(LambdaStarL(1,:,3))' squeeze(LambdaStarL(1,:,4))' ];
% z=1
% plot(VGrid(z,squeeze(ExitFlag(z,:)))' ,squeeze(ConsStarRatio(z,squeeze(ExitFlag(z,:)),1)))
% hold on
% plot(VGrid(z,1:end)' ,squeeze(ConsStarRatio(z,1:end,3)))
