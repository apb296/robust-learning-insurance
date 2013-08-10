% Diagnostics and policyruls
clc
clear all
close all
mkdir('Plots')

AmbFileName='PrivateInformationAmb.mat';
NoAmbFileName='PrivateInformationNoAmb.mat';
AmbData=load (['Data/' AmbFileName]);
NoAmbData=load (['Data/' NoAmbFileName]);
%AmbSimData=load(['Data\Sim'  AmbFileName]);
%NoAmbSimData=load(['Data\Sim' NoAmbFileName ]);
%AmbExitTimeData=load(['Data\ExitTime' AmbFileName ]);
%NoAmbExitTimeData=load(['Data\ExitTime' NoAmbFileName ]);

vstarguessind=max(find(abs(AmbData.PolicyRulesStore(:,1)-AmbData.Para.y+AmbData.Para.Delta) < 6e-6));
vhathatguessind=max((find(AmbData.MuStore(2:end-1,2) > 1e-6)));
vhatguessind=round(vhathatguessind/2)+min((find(AmbData.MuStore(vhathatguessind/2:end-1,3) > 1e-6)));
vstarstarguessind=min(find(abs(AmbData.PolicyRulesStore(:,2)- AmbData.Para.Delta) <  7e-6));

AmbData.vstar=.5*(AmbData.domain(vstarguessind)+AmbData.domain(vstarguessind+1));
AmbData.vstarstar=mean([AmbData.domain(vstarstarguessind-1),AmbData.domain(vstarstarguessind)]);
AmbData.vhat=.5*(AmbData.domain(vhatguessind)+AmbData.domain(vhatguessind+1));
AmbData.vhathat=.5*(AmbData.domain(vhathatguessind)+AmbData.domain(vhathatguessind+1));

vstarguessind=max(find(abs(NoAmbData.PolicyRulesStore(:,1)-NoAmbData.Para.y+NoAmbData.Para.Delta) < 6e-6));
vhathatguessind=max((find(NoAmbData.MuStore(2:end-1,2) > 1e-6)));
vhatguessind=round(vhathatguessind/2)+min((find(NoAmbData.MuStore(vhathatguessind/2:end-1,3) > 1e-6)));
vstarstarguessind=min(find(abs(NoAmbData.PolicyRulesStore(:,2)- NoAmbData.Para.Delta) <  7e-6));

NoAmbData.vstar=.5*(NoAmbData.domain(vstarguessind)+NoAmbData.domain(vstarguessind+1));
NoAmbData.vstarstar=mean([NoAmbData.domain(vstarstarguessind-1),NoAmbData.domain(vstarstarguessind)]);
NoAmbData.vhat=.5*(NoAmbData.domain(vhatguessind)+NoAmbData.domain(vhatguessind+1));
NoAmbData.vhathat=.5*(NoAmbData.domain(vhathatguessind)+NoAmbData.domain(vhathatguessind+1));



%vstar=fzero(@(x) ResFindDomainPartition_star(x,AmbData.c,AmbData.Q,AmbData.Para,AmbData.domain,AmbData.PolicyRulesStore), [AmbData.domain(vstarguessind)]);
%vstarstar=fzero(@(x) ResFindDomainPartition_starstar(x,AmbData.c,AmbData.Q,AmbData.Para,AmbData.domain,AmbData.PolicyRulesStore), AmbData.domain(vstarstarguessind-1), AmbData.domain(vstarstarguessind));



vstarguessind=max(find(abs(NoAmbData.PolicyRulesStore(:,1)-NoAmbData.Para.y+NoAmbData.Para.Delta) < 0.00001));
NoAmbData.vstar=.5*(NoAmbData.domain(vstarguessind)+NoAmbData.domain(vstarguessind+1));
%vstar=fzero(@(x) ResFindDomainPartition_star(x,NoAmbData.c,NoAmbData.Q,NoAmbData.Para,NoAmbData.domain,NoAmbData.PolicyRulesStore), [NoAmbData.domain(vstarguessind)]);
vstarstarguessind=min(find(abs(NoAmbData.PolicyRulesStore(:,2)- NoAmbData.Para.Delta) < 0.00001));
%vstarstar=fzero(@(x) ResFindDomainPartition_starstar(x,NoAmbData.c,NoAmbData.Q,NoAmbData.Para,NoAmbData.domain,NoAmbData.PolicyRulesStore), NoAmbData.domain(vstarstarguessind-1), NoAmbData.domain(vstarstarguessind));
NoAmbData.vstarstar=mean([NoAmbData.domain(vstarstarguessind-1),NoAmbData.domain(vstarstarguessind)]);



figure()
subplot(1,2,1)
%plot(NoAmbData.domain(:),(funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.domain(:))-NoAmbData.QNew')./NoAmbData.QNew','-r','LineWidth',2)
subplot(1,2,2)
%plot(NoAmbData.domain(:),(funeval(AmbData.c,AmbData.Q,AmbData.domain(:))-AmbData.QNew')./AmbData.QNew','-r','LineWidth',2)



figure()
subplot(1,2,1)
%plot(NoAmbData.domain(:),(funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.domain(:),1)+NoAmbData.LambdaStore')./NoAmbData.LambdaStore','-r','LineWidth',2)
subplot(1,2,2)
%plot(NoAmbData.domain(:),(funeval(AmbData.c,AmbData.Q,AmbData.domain(:),1)-AmbData.LambdaStore')./AmbData.LambdaStore','-r','LineWidth',2)






% Value Functions
figure()
subplot(1,2,1)
plot(NoAmbData.domain(:),funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.domain(:)),'-r','LineWidth',2)
subplot(1,2,2)
plot(NoAmbData.domain(:),funeval(AmbData.c,AmbData.Q,NoAmbData.domain(:)),'-k','LineWidth',2)

% Value Functions
figure()
subplot(1,2,1)
plot(NoAmbData.domain(:),funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.domain(:)),'-r','LineWidth',2)
subplot(1,2,2)
plot(AmbData.domain(:),funeval(AmbData.c,AmbData.Q,AmbData.domain(:)),'-k','LineWidth',2)





% Curvature of Value Function
figure()
plot(NoAmbData.PolicyRulesStore(:,1),-funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.domain(:),1),'-r','LineWidth',2)
hold on
plot(AmbData.PolicyRulesStore(:,1),-funeval(AmbData.c,AmbData.Q,AmbData.domain(:),1),'-k','LineWidth',2)



% Consumption diff as a function of v
figure()
subplot(2,1,1)
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,2)-NoAmbData.PolicyRulesStore(:,1),'-r','LineWidth',2)
vline([NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar],':b')
xlabel('v')
ylabel('$\tilde{\Delta}$','Interpreter','Latex')
%set(gca,'FontSize',10)
title('$\theta=\infty$','Interpreter','Latex')
%set(gca,'XTick',[NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar])
%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})

subplot(2,1,2)
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,2)-AmbData.PolicyRulesStore(:,1),'-k','LineWidth',2)
vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
%set(gca,'XTick',[AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar])
%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})
xlabel('v')
ylabel('$\tilde{\Delta}$','Interpreter','Latex')
title('$\theta <\infty$','Interpreter','Latex')
print(gcf,'-dpng','Plots/figTildeDelta_v.png')


% Consumption level as a function of v

figure()
subplot(2,1,1)
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,1),':r','LineWidth',2)
hold on
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,2),'-r','LineWidth',2)
vline([NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar],':b')
%set(gca,'XTick',[NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar])
%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})
xlabel('v')
ylabel('$c_1$','Interpreter','Latex')
legend('c(s_l)','c(s_h)')
title('$\theta=\infty$','Interpreter','Latex')

subplot(2,1,2)
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,1),':k','LineWidth',2)
hold on
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,2),'-k','LineWidth',2)
vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
%set(gca,'XTick',[AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar])
%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})
xlabel('v')
ylabel('$c$','Interpreter','Latex')
legend('c(s_l)','c(s_h)')
title('$\theta<\infty$','Interpreter','Latex')
print(gcf,'-dpng','Plots/figConsumptionMenu_v.png')



% Consumption diff as a function of lambda
figure()
lambdaind_=2;
lambdaind=299;
plot(NoAmbData.LambdaStore(lambdaind_:lambdaind),NoAmbData.PolicyRulesStore(lambdaind_:lambdaind,2)-NoAmbData.PolicyRulesStore(lambdaind_:lambdaind,1),'-r','LineWidth',2)
hold on 
plot(AmbData.LambdaStore(lambdaind_:lambdaind),AmbData.PolicyRulesStore(lambdaind_:lambdaind,2)-AmbData.PolicyRulesStore(lambdaind_:lambdaind,1),'-k','LineWidth',2)
xlabel('$\lambda$','Interpreter','Latex')
ylabel('Diff Cons')
legend('\theta=\infty','\theta <\infty')
print(gcf,'-dpng','Plots/figTildeDelta_lambda.png')





figure()
subplot(2,1,1)
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,3)-NoAmbData.domain(:),':r','LineWidth',2)
hold on
plot(NoAmbData.domain' ,0*NoAmbData.PolicyRulesStore(:,4),'b-','LineWidth',2)
hold on
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,4)-NoAmbData.domain(:),'-r','LineWidth',2)
vline([NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar],':b')
%set(gca,'XTick',[NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar])
%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})

xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('${v}^{*}-v$','Interpreter','Latex','FontSize',15)
legend('{v}^{*}(s_l)','{v}^{*}(s_h)')
title('$\theta=\infty$','Interpreter','Latex')

subplot(2,1,2)
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,3)-AmbData.domain(:),':k','LineWidth',2)
hold on
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,4)-AmbData.domain(:),'-k','LineWidth',2)
hold on
plot(AmbData.domain' ,0*AmbData.PolicyRulesStore(:,4),'b-','LineWidth',2)

vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
%set(gca,'XTick',[AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar])
%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})

xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('${v}^{*}-v$','Interpreter','Latex','FontSize',15)
legend('{v}^{*}(s_l)','{v}^{*}(s_h)')
title('$\theta<\infty$','Interpreter','Latex')
print(gcf,'-dpng','Plots/figDeltaVstar_v.png')



figure()
plot(AmbData.domain(:),[AmbData.DistortedBeliefsAgent1Store(:,1)],':k','LineWidth',2)
hold on
plot(AmbData.domain(:),[AmbData.DistortedBeliefsAgent1Store(:,2)],'-k','LineWidth',2)
hold on
plot(AmbData.domain(:),[AmbData.DistortedBeliefsAgent2Store(:,1)],'-r','LineWidth',2)
hold on
plot(AmbData.domain(:),[AmbData.DistortedBeliefsAgent2Store(:,2)],':r','LineWidth',2)
hold on
plot(AmbData.domain(:),[AmbData.Para.pl(1)]*ones(length(AmbData.domain),1),':b','LineWidth',2)
hold on
plot(AmbData.domain(:),[AmbData.Para.ph(1)]*ones(length(AmbData.domain),1),'-b','LineWidth',2)

vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
%%set(gca,'XTick',[AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar])
%%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})

xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('$\tilde{P}^i$','Interpreter','Latex','FontSize',15)
legend('Pr{y^1=y_l}','Pr{y^1=y_h}','Pr{y^2=y_h}','Pr{y^2=y_l}')
print(gcf,'-dpng','Plots/figDistProbabilities_v.png')


NoAmbAcrossSampleVHist=[];
NoAmbAcrossSampleCHist=[];
AmbAcrossSampleVHist=[];
AmbAcrossSampleCHist=[];

for k=1 :NoAmbSimData.K
    NoAmbAcrossSampleVHist=[NoAmbAcrossSampleVHist NoAmbSimData.SimData(k).vHist(NoAmbSimData.NumSim/2:NoAmbSimData.NumSim)];
    NoAmbAcrossSampleCHist=[NoAmbAcrossSampleCHist NoAmbSimData.SimData(k).cHist(NoAmbSimData.NumSim/2:NoAmbSimData.NumSim)'];
end

for k=1 :AmbSimData.K
    AmbAcrossSampleVHist=[AmbAcrossSampleVHist AmbSimData.SimData(k).vHist(AmbSimData.NumSim/2:AmbSimData.NumSim)];
    AmbAcrossSampleCHist=[AmbAcrossSampleCHist AmbSimData.SimData(k).cHist(AmbSimData.NumSim/2:AmbSimData.NumSim)'];
end




% ERGODIC DISTRIBUTIONS 
figure()
subplot(2,2,1)
[f,xi] = ksdensity(NoAmbAcrossSampleVHist);
plot(xi,f,'r','LineWidth',2)
vline([NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar],':b')
xlabel('$v$','Interpreter','Latex','FontSize',15)
title('$\theta=\infty$','Interpreter','Latex')
subplot(2,2,2)
[f,xi] = ksdensity(AmbAcrossSampleVHist);
plot(xi,f,'k','LineWidth',2)
vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
xlabel('$v$','Interpreter','Latex','FontSize',15)
title('$\theta <\infty$','Interpreter','Latex')


subplot(2,2,3)
hist(NoAmbAcrossSampleCHist,200);
xlabel('$c$','Interpreter','Latex','FontSize',15)
title('$\theta=\infty$','Interpreter','Latex')
subplot(2,2,4)
[f,xi] = ksdensity(AmbAcrossSampleCHist);
plot(xi,f,'k','LineWidth',2)
xlabel('$c$','Interpreter','Latex','FontSize',15)
title('$\theta <\infty$','Interpreter','Latex')
print(gcf,'-dpng','Plots/figErgodicDistributions.png')


% SAMPLE PATHS

figure()
for k=1:NoAmbSimData.K
subplot(3,1,k)
plot(NoAmbSimData.SimData(k).cHist,'r')
hold on
plot(AmbSimData.SimData(k).cHist,'k')
end
print(gcf,'-dpng','Plots/fig3SamplePaths.png')











% ExitTimes

figure()
subplot(2,1,2)
plot(AmbExitTimeData.v0(:),AmbExitTimeData.ExitProbabilities(:,1),'-k','LineWidth',2)
hold on
plot(AmbExitTimeData.v0(:),AmbExitTimeData.ExitProbabilities(:,2),':k','LineWidth',2)

vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
%%set(gca,'XTick',[AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar])
%%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})

xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('ExitTime','Interpreter','Latex','FontSize',15)
legend('Agent 2 exits','Agent 1 exits')
title('$\theta<\infty$','Interpreter','Latex')

subplot(2,1,1)
plot(NoAmbExitTimeData.v0(:),NoAmbExitTimeData.ExitProbabilities(:,1),'-r','LineWidth',2)
hold on
plot(NoAmbExitTimeData.v0(:),NoAmbExitTimeData.ExitProbabilities(:,2),':r','LineWidth',2)
xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('ExitTime','Interpreter','Latex','FontSize',15)
legend('Agent 2 exits','Agent 1 exits')
title('$\theta=\infty$','Interpreter','Latex')

vline([NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar],':b')
%%set(gca,'XTick',[NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar])
%%set(gca,'XTickLabel',{'v_x','v_y','v_yy','v_xx'})

print(gcf,'-dpng','Plots/figExitProbabilities_v.png')



figure()
subplot(2,1,2)
plot(AmbExitTimeData.v0(:),1-AmbExitTimeData.ET(:,1),'-k','LineWidth',2)
hold on
plot(AmbExitTimeData.v0(:),1-AmbExitTimeData.ET(:,2),':k','LineWidth',2)
xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('ExitTime','Interpreter','Latex','FontSize',15)
legend('Agent 2 exits','Agent 1 exits')

subplot(2,1,1)
plot(NoAmbExitTimeData.v0(:),1-NoAmbExitTimeData.ET(:,1),'-r','LineWidth',2)
hold on
plot(NoAmbExitTimeData.v0(:),1-NoAmbExitTimeData.ET(:,2),':r','LineWidth',2)
xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('Average ExitTime','Interpreter','Latex','FontSize',15)
legend('Agent 2 exits','Agent 1 exits')
print(gcf,'-dpng','Plots/figExitTimes_v.png')





