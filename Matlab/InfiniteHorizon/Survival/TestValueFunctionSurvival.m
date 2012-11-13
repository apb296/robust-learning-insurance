
% This file generates plots that summarize the survival policy functions


clear all
close all
clc


SetParaStruc;
addpath(genpath([BaseDirectory SL 'compecon2011']))
coeffname{1}='Data/FinalCAmb.mat';
coeffname{2}='Data/FinalCNoAmb.mat';
%coeffname='Data/FinalCAmbSparse.mat'

DGP{1}='RefModelAgent1';
DGP{2}='RefModelAgent2';
DGP{3}='DistModelAgent1';
DGP{4}='DistModelAgent2';
for ex=1:2
    
load([coeffname{ex}])
VPlotGrid(ex,:)=linspace((max(Q(1).a,Q(2).a)),( min(Q(2).b,Q(1).b)),25);

for y=1:Para.YSize
    tic
    x0=[];

    for v=1:length(VPlotGrid)
        resQNew=getQNew(y,VPlotGrid(ex,v),c,Q,Para,x0);
        QNew(ex,y,v)=resQNew.QNew;
        ErrorInValueApprox(ex,y,v)=(funeval(c(y,:)',Q(y),[VPlotGrid(ex,v)])-QNew(ex,y,v))/(QNew(ex,y,v));
        ErrorInEnvelopeThm(ex,y,v)=funeval(c(y,:)',Q(y),[VPlotGrid(ex,v)],1)+ resQNew.Lambda;
        LambdaStarL(ex,y,v,:)=resQNew.LambdaStarL;
        Lambda(ex,y,v)=resQNew.Lambda;
          Cons(ex,y,v)=resQNew.Cons;
         ConsStarRatio(ex,y,v,:)=resQNew.ConsStarRatio;
         ConsStar(ex,y,v,:)=resQNew.ConsStar./Para.Y';
         ExitFlag(ex,y,v)=resQNew.ExitFlag;
                VStar(ex,y,v,:)=resQNew.VStar;
                DelVStar(ex,y,v,:)=resQNew.VStar-VPlotGrid(v);
        Distfactor1=resQNew.Distfactor1;
        Distfactor2=resQNew.Distfactor2;
Distorted_P_agent1(ex,y,v,:)=Para.P1(y,:).*Distfactor1;                                  % Distorted Beleifs Agent 1
Distorted_P_agent2(ex,y,v,:)=Para.P2(y,:).*Distfactor2;         % Distorted Beleifs Agent 2

for dgp_ind=1:length(DGP)
    dgp=DGP{dgp_ind};
    switch dgp
        case 'RefModelAgent1'
           y_dist=P1(y,:);
        case 'RefModelAgent2'
           y_dist=P2(y,:);
            case 'DistModelAgent1'
            y_dist=P1(y,:).*resQNew.Distfactor1;   
            case 'DistModelAgent2'
            y_dist=P2(y,:).*resQNew.Distfactor2;   
            
    end
   
    Emlogm_distmarg_agent1(ex,y,v,dgp_ind)=sum((squeeze(Distorted_P_agent1(ex,y,v,:))'./y_dist).*log((squeeze(Distorted_P_agent1(ex,y,v,:))'./y_dist)).*y_dist);                   % Relative Entropy for Agent 1
Emlogm_distmarg_agent2(ex,y,v,dgp_ind)=sum((squeeze(Distorted_P_agent2(ex,y,v,:))'./y_dist).*log((squeeze(Distorted_P_agent2(ex,y,v,:))'./y_dist)).*y_dist);                   % Relative Entropy for Agent 1

end

                x0=[Cons(ex,y,v) VStar(ex,y,v,1) VStar(ex,y,v,1)];
       

    end
 
end
end

% Figure : Error in value function approximation
% caption : The figure plots the relative error in the functional
% approximation
figure()
subplot(2,1,1)
plot(ErrorInValueApprox(1,:)')
title('$\theta_1 < \infty$','Interpreter','Latex')
subplot(2,1,2)
plot(ErrorInValueApprox(2,:)')
title('$\theta_1 = \infty$','Interpreter','Latex')


% Figure : Error in Envelope theorem
% caption : The figure plots the relative error in the envelope theorem

figure()
subplot(2,1,1)
plot(ErrorInEnvelopeThm(1,:)')
title('$\theta_1 < \infty$','Interpreter','Latex')
subplot(2,1,2) 
plot(ErrorInEnvelopeThm(2,:)')
title('$\theta_1 = \infty$','Interpreter','Latex')

figure()



% Figure lambdastar/lambda as a function of v
% caption : The figure plots the log change in the lagrange multiplier as a
% function of the continuation value. The solid (dotted) line refers to
% y(z^*)=y_l (y_h)
figure()
subplot(2,1,1)
plot(VPlotGrid(1,:),log((squeeze(LambdaStarL(1,1,:,1)))),'k','LineWidth',2)
hold on
plot(VPlotGrid(1,:),log((squeeze(LambdaStarL(1,1,:,2)))),':k','LineWidth',2)
axis tight
ylabel('$\Delta \log \lambda (y^*) $','Interpreter','Latex')
xlabel('Agent 2 promised value - v')
title('$\theta_1 <\infty$','Interpreter','Latex')
legend('y^*=y_l','y^*=y_h')
hold on
plot(VPlotGrid(1,:),log((squeeze(LambdaStarL(1,1,:,1))))*0,'-r','LineWidth',.8)

subplot(2,1,2) 
plot(VPlotGrid(2,:),log((squeeze(LambdaStarL(2,1,:,1)))),'k','LineWidth',2)
hold on
plot(VPlotGrid(2,:),log((squeeze(LambdaStarL(2,1,:,2)))),':k','LineWidth',2)
ylabel('$\Delta \log \lambda (y^*) $','Interpreter','Latex')
xlabel('Agent 2 promised value - v')
title(' $\theta_1 =\infty$','Interpreter','Latex')
legend('y^*=y_l','y^*=y_h')
hold on
plot(VPlotGrid(2,:),log((squeeze(LambdaStarL(2,1,:,1))))*0,'-r','LineWidth',.8)
print(gcf,'-dpng','Graphs/SurvivalGrowthRateLambdaStar.png')



% Figure lambdastar/lambda as a function of lambda
% caption : The figure plots the log change in the lagrange multiplier as a
% function of lambda. The solid (dotted) line refers to
% y(z^*)=y_l (y_h)
figure()
subplot(2,1,1)
plot(squeeze(Lambda(1,1,:)),log((squeeze(LambdaStarL(1,1,:,1)))),'k','LineWidth',2)
hold on
plot(squeeze(Lambda(1,1,:)),log((squeeze(LambdaStarL(1,1,:,2)))),':k','LineWidth',2)
axis tight
ylabel('$\Delta \log \lambda (y^*) $','Interpreter','Latex')
xlabel('\lambda')
title(' $\theta_1 <\infty$','Interpreter','Latex')
legend('y^*=y_l','y^*=y_h')


subplot(2,1,2) 
plot(squeeze(Lambda(2,1,:)),log((squeeze(LambdaStarL(2,1,:,1)))),'k','LineWidth',2)
hold on
plot(squeeze(Lambda(2,1,:)),log((squeeze(LambdaStarL(2,1,:,2)))),':k','LineWidth',2)
ylabel('$\Delta \log \lambda (y^*) $','Interpreter','Latex')
xlabel('\lambda')
title(' $\theta_1 <\infty$','Interpreter','Latex')
legend('y^*=y_l','y^*=y_h')

print(gcf,'-dpng','Graphs/SurvivalGrowthRateLambdaStarLambda.png')


ex=2
y=2
v= 1.5860

load([coeffname{ex}])
VPlotGrid(ex,:)=linspace((max(Q(1).a,Q(2).a)),( min(Q(2).b,Q(1).b)),25);
xtest=[1 v];
xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules);
resQNew=getQNew(y,v,c,Q,Para,xInit)
        