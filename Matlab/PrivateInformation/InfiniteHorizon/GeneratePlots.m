% Diagnostics and policyruls
clc
clear all
close all
mkdir('Plots')
k=1
AmbData=load ('Data/PrivateInformationHighAmb.mat');
NoAmbData=load ('Data/PrivateInformationNoAmb.mat');


AmbSimData=load('Data\SimPrivateInformationHighAmb.mat');
NoAmbSimData=load('Data\SimPrivateInformationNoAmb.mat');

vstarguessind=max(find(abs(AmbData.PolicyRulesStore(:,1)-AmbData.Para.y+AmbData.Para.Delta) < 6e-6));
vhathatguessind=max((find(AmbData.MuStore(2:end-1,2) > 1e-6)));
vhatguessind=vhathatguessind/2+min((find(AmbData.MuStore(vhathatguessind/2:end-1,3) > 1e-6)));
vstarstarguessind=min(find(abs(AmbData.PolicyRulesStore(:,2)- AmbData.Para.Delta) <  7e-6));

AmbData.vstar=.5*(AmbData.domain(vstarguessind)+AmbData.domain(vstarguessind+1));
AmbData.vstarstar=mean([AmbData.domain(vstarstarguessind-1),AmbData.domain(vstarstarguessind)]);
AmbData.vhat=.5*(AmbData.domain(vhatguessind)+AmbData.domain(vhatguessind+1));
AmbData.vhathat=.5*(AmbData.domain(vhathatguessind)+AmbData.domain(vhathatguessind+1));


vstarguessind=max(find(abs(NoAmbData.PolicyRulesStore(:,1)-NoAmbData.Para.y+NoAmbData.Para.Delta) < 6e-6));
vhathatguessind=max((find(NoAmbData.MuStore(2:end-1,2) > 1e-6)));
vhatguessind=vhathatguessind/2+min((find(NoAmbData.MuStore(vhathatguessind/2:end-1,3) > 1e-6)));
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
subplot(1,2,1)
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,2)-NoAmbData.PolicyRulesStore(:,1),'-r','LineWidth',2)
vline([NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar],':b')
xlabel('v')
ylabel('$\tilde{\Delta}$','Interpreter','Latex')
title('$\theta=\infty$','Interpreter','Latex')
subplot(1,2,2)
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,2)-AmbData.PolicyRulesStore(:,1),'-k','LineWidth',2)
vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
xlabel('v')
ylabel('$\tilde{\Delta}$','Interpreter','Latex')
title('$\theta <\infty$','Interpreter','Latex')
print(gcf,'-dpng','Plots/figTildeDelta_v.png')


% Consumption level as a function of v

figure()
subplot(1,2,1)
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,1),':r','LineWidth',2)
hold on
plot(NoAmbData.domain(:),NoAmbData.PolicyRulesStore(:,2),'-r','LineWidth',2)
vline([NoAmbData.vstar,NoAmbData.vhat,NoAmbData.vhathat,NoAmbData.vstarstar],':b')
xlabel('v')
ylabel('$c$','Interpreter','Latex')
legend('c(z_1)','c(z_2)')
title('$\theta=\infty$','Interpreter','Latex')

subplot(1,2,2)
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,1),':k','LineWidth',2)
hold on
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,2),'-k','LineWidth',2)
vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
xlabel('v')
ylabel('$c$','Interpreter','Latex')
legend('c(z_1)','c(z_2)')
title('$\theta=\infty$','Interpreter','Latex')
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
xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('${v}^{*}-v$','Interpreter','Latex','FontSize',15)
legend('{v}^{*}(z_1)','{v}^{*}(z_2)')
title('$\theta=\infty$','Interpreter','Latex')

subplot(2,1,2)
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,3)-AmbData.domain(:),':k','LineWidth',2)
hold on
plot(AmbData.domain(:),AmbData.PolicyRulesStore(:,4)-AmbData.domain(:),'-k','LineWidth',2)
hold on
plot(AmbData.domain' ,0*AmbData.PolicyRulesStore(:,4),'b-','LineWidth',2)

vline([AmbData.vstar,AmbData.vhat,AmbData.vhathat,AmbData.vstarstar],':b')
xlabel('$v$','Interpreter','Latex','FontSize',15)
ylabel('${v}^{*}-v$','Interpreter','Latex','FontSize',15)
legend('{v}^{*}(z_1)','{v}^{*}(z_2)')
title('$\theta=\infty$','Interpreter','Latex')

print(gcf,'-dpng','Plots/figDeltaVstar_v.png')






% Vstar-vas a function of v
figure()
subplot(2,2,1)
plot(NoAmbData.domain' ,NoAmbData.PolicyRulesStore(:,3)-repmat(NoAmbData.domain',1,1),':r','LineWidth',2)
%hold on
%plot(NoAmbData.domain' ,NoAmbData.PolicyRulesStore(:,3)*NoAmbData.Para.pl(1)+NoAmbData.PolicyRulesStore(:,4)*NoAmbData.Para.ph(1)-repmat(NoAmbData.domain',1,1),'r','LineWidth',2)

hold on
plot(NoAmbData.domain' ,NoAmbData.PolicyRulesStore(:,4)-repmat(NoAmbData.domain',1,1),'-r','LineWidth',2)
hold on
plot(NoAmbData.domain' ,0*NoAmbData.PolicyRulesStore(:,4),'b-','LineWidth',2)

vline([NoAmbData.vstar,NoAmbData.vstarstar],':b')

subplot(2,2,2)
[f,xi] = ksdensity(NoAmbSimData.SimData(k).vHist(NoAmbSimData.NumSim/2:end))
plot(xi,f)
vline([NoAmbData.vstar,NoAmbData.vstarstar],':b')


subplot(2,2,3)
plot(AmbData.domain' ,AmbData.PolicyRulesStore(:,3)-repmat(AmbData.domain',1,1),':k','LineWidth',2)
hold on
plot(AmbData.domain' ,AmbData.PolicyRulesStore(:,4)-repmat(AmbData.domain',1,1),'-k','LineWidth',2)
hold on
plot(AmbData.domain' ,AmbData.PolicyRulesStore(:,4)*0,'b-','LineWidth',2)
vline([AmbData.vstar,AmbData.vstarstar],':b')


subplot(2,2,4)
[f,xi] = ksdensity(AmbSimData.SimData(k).vHist(AmbSimData.NumSim/2:end))
plot(xi,f)
vline([AmbData.vstar,AmbData.vstarstar],':b')





figure()
subplot(2,2,1)
hist(NoAmbSimData.SimData(k).cHist(NoAmbSimData.NumSim/2:end),100)
subplot(2,2,2)
hist(AmbSimData.SimData(k).cHist(AmbSimData.NumSim/2:end),100)   
subplot(2,2,3)
hist(NoAmbSimData.SimData(k).LambdaHist(NoAmbSimData.NumSim/2:end),100)
subplot(2,2,4)
hist(AmbSimData.SimData(k).LambdaHist(AmbSimData.NumSim/2:end),100)





figure()
subplot(2,2,1)
plot(NoAmbSimData.SimData(k).cHist(1:500),'r')
subplot(2,2,2)
plot(AmbSimData.SimData(k).cHist(1:500),'k')   
subplot(2,2,3)
plot(NoAmbSimData.SimData(k).LambdaHist(1:500),'r')
subplot(2,2,4)
plot(AmbSimData.SimData(k).LambdaHist(1:500),'k')





figure()
subplot(2,1,1)
plot(NoAmbSimData.SimData(k).cHist,'r')
hold on
plot(AmbSimData.SimData(k).cHist,'k')
subplot(2,1,2)
plot(NoAmbSimData.SimData(k).LambdaHist,'r')
hold on
plot(AmbSimData.SimData(k).LambdaHist,'k')


figure()
plot(NoAmbSimData.SimData(k).cHistMenu(:,2)-NoAmbSimData.SimData(k).cHistMenu(:,1),'r')
hold on
plot(AmbSimData.SimData(k).cHistMenu(:,2)-AmbSimData.SimData(k).cHistMenu(:,1),'k')


ctr=3
lambda1=-funeval(AmbData.c,AmbData.Q,AmbData.PolicyRulesStore(ctr,3),1)

lambda2=-funeval(AmbData.c,AmbData.Q,AmbData.PolicyRulesStore(ctr,4),1)

Elambdastar=lambda1*AmbData.DistortedBeliefsAgent1Store(ctr,1)+lambda2*AmbData.DistortedBeliefsAgent1Store(ctr,2)
lambda=AmbData.LambdaStore(ctr)
mu1_z2=AmbData.MuStore(ctr,2)
Elambdastar
lambda+mu1_z2*(lambda1-lambda2)






figure()
AmbData.TildeDeltaAgent1=[u(AmbData.PolicyRulesStore(:,2),AmbData.Para.ra)-u(AmbData.PolicyRulesStore(:,1),AmbData.Para.ra) AmbData.Para.beta*(funeval(AmbData.c,AmbData.Q,AmbData.PolicyRulesStore(:,4))-funeval(AmbData.c,AmbData.Q,AmbData.PolicyRulesStore(:,3)))]
AmbData.TildeDeltaAgent2=[u(AmbData.Para.y-AmbData.PolicyRulesStore(:,1),AmbData.Para.ra)-u(AmbData.Para.y-AmbData.PolicyRulesStore(:,2),AmbData.Para.ra) AmbData.Para.beta*(AmbData.PolicyRulesStore(:,3)- AmbData.PolicyRulesStore(:,4))]
NoAmbData.TildeDeltaAgent1=[u(NoAmbData.PolicyRulesStore(:,2),NoAmbData.Para.ra)-u(NoAmbData.PolicyRulesStore(:,1),NoAmbData.Para.ra)  NoAmbData.Para.beta*(funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.PolicyRulesStore(:,4))-funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.PolicyRulesStore(:,3)))]

plot(AmbData.LambdaStore,[ AmbData.TildeDeltaAgent1(:,1)./funeval(AmbData.c,AmbData.Q,AmbData.PolicyRulesStore(:,3))],'k')
hold on
plot(NoAmbData.LambdaStore,[ NoAmbData.TildeDeltaAgent1(:,1)./funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.PolicyRulesStore(:,3))],'r')

plot(AmbData.LambdaStore,[ AmbData.TildeDeltaAgent1(:,2)],':k')
hold on
plot(NoAmbData.LambdaStore,[ NoAmbData.TildeDeltaAgent1(:,2)],':r')


figure()
plot(AmbData.LambdaStore(1:end-1),[AmbData.DistortedBeliefsAgent1Store(1:end-1,:) AmbData.DistortedBeliefsAgent2Store(1:end-1,:)])
hold on
plot(NoAmbData.LambdaStore(1:end-1),[NoAmbData.DistortedBeliefsAgent1Store(1:end-1,:) NoAmbData.DistortedBeliefsAgent2Store(1:end-1,:)])





NoAmbData.TildeDeltaAgent1=u(NoAmbData.PolicyRulesStore(:,2),NoAmbData.Para.ra)-u(NoAmbData.PolicyRulesStore(:,1),NoAmbData.Para.ra)+ NoAmbData.Para.beta*(funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.PolicyRulesStore(:,4))-funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.PolicyRulesStore(:,3)))
NoAmbData.TildeDeltaAgent2=u(NoAmbData.Para.y-NoAmbData.PolicyRulesStore(:,1),NoAmbData.Para.ra)-u(NoAmbData.Para.y-NoAmbData.PolicyRulesStore(:,2),NoAmbData.Para.ra)+ NoAmbData.Para.beta*(NoAmbData.PolicyRulesStore(:,3)- NoAmbData.PolicyRulesStore(:,4))


figure()
subplot(1,2,1)
plot(AmbData.LambdaStore,[ AmbData.TildeDeltaAgent1 AmbData.TildeDeltaAgent2],'k')
hold on
plot(NoAmbData.LambdaStore,[ NoAmbData.TildeDeltaAgent1 NoAmbData.TildeDeltaAgent2],'r')



% Comparative Optimal Contract - Consumption Levels
figure()
plot(NoAmbData.LambdaStore(:),NoAmbData.PolicyRulesStore(:,1),':r','LineWidth',2)
hold on
plot(NoAmbData.LambdaStore(:),NoAmbData.PolicyRulesStore(:,2),'-r','LineWidth',2)
hold on 
plot(AmbData.LambdaStore(:),AmbData.PolicyRulesStore(:,1),':k','LineWidth',2)
hold on
plot(AmbData.LambdaStore(:),AmbData.PolicyRulesStore(:,2),'-k','LineWidth',2)
xlabel('$\lambda$','Interpreter','Latex')
ylabel('Consumption')
% Comparative  Optimal Contract - Consumption Diff

% Comparative  Optimal Contract  - Change in Multiplier
AmbDatadomain=AmbData.domain(1:end-1);
NoAmbDatadomain=NoAmbData.domain(1:end-1);

figure()
plot(-funeval(NoAmbData.c,NoAmbData.Q,NoAmbDatadomain',1),-funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.PolicyRulesStore(1:end-1,3),1)+funeval(NoAmbData.c,NoAmbData.Q,NoAmbDatadomain',1),':r','LineWidth',2)
hold on
plot(-funeval(NoAmbData.c,NoAmbData.Q,NoAmbDatadomain',1),-funeval(NoAmbData.c,NoAmbData.Q,NoAmbData.PolicyRulesStore(1:end-1,4),1)+funeval(NoAmbData.c,NoAmbData.Q,NoAmbDatadomain',1),'-r','LineWidth',2)
hold on
plot(-funeval(AmbData.c,AmbData.Q,AmbDatadomain',1),-funeval(AmbData.c,AmbData.Q,AmbData.PolicyRulesStore(1:end-1,3),1)+funeval(AmbData.c,AmbData.Q,AmbDatadomain',1),':k','LineWidth',2)
hold on
plot(-funeval(AmbData.c,AmbData.Q,AmbDatadomain',1),-funeval(AmbData.c,AmbData.Q,AmbData.PolicyRulesStore(1:end-1,4),1)+funeval(AmbData.c,AmbData.Q,AmbDatadomain',1),'-k','LineWidth',2)

xlabel('$\lambda$','Interpreter','Latex')
ylabel('$\lambda^{*}$','Interpreter','Latex')





% Optimal Contract  - Delta v* as a function of v 


% Optimal Contract  - Binding constraints
figure()
subplot(2,1,1)
plot(NoAmbData.LambdaStore(:),NoAmbData.MuStore(:,2),':r','LineWidth',2)
hold on
plot(NoAmbData.LambdaStore(:),NoAmbData.MuStore(:,3),'-r','LineWidth',2)

subplot(2,1,2)
plot(AmbData.LambdaStore(:),AmbData.MuStore(:,2),':k','LineWidth',2)
hold on
plot(AmbData.LambdaStore(:),AmbData.MuStore(:,3),'-k','LineWidth',2)






figure()
subplot(1,2,1)
[AX,H1,H2] = plotyy(NoAmbData.domain',NoAmbData.PolicyRulesStore(:,2)-NoAmbData.PolicyRulesStore(:,1),NoAmbData.domain',NoAmbData.PolicyRulesStore(:,3)-NoAmbData.PolicyRulesStore(:,4),'plot');


subplot(1,2,2)
[AX,H1,H2] = plotyy(AmbData.domain',AmbData.PolicyRulesStore(:,2)-AmbData.PolicyRulesStore(:,1),AmbData.domain',AmbData.PolicyRulesStore(:,3)-AmbData.PolicyRulesStore(:,4),'plot');



figure()
plot(NoAmbData.PolicyRulesStore(:,1),NoAmbData.PolicyRulesStore(:,2)-NoAmbData.PolicyRulesStore(:,1),'-r','LineWidth',2)
hold on 
plot(AmbData.PolicyRulesStore(:,1),AmbData.PolicyRulesStore(:,2)-AmbData.PolicyRulesStore(:,1),'-k','LineWidth',2)
xlabel('$c$','Interpreter','Latex')
ylabel('Diff Cons')

figure()
plot(NoAmbSimData.SimData(2).LambdaHist,NoAmbSimData.SimData(2).cHist)
plot(AmbSimData.SimData(2).LambdaHist,AmbSimData.SimData(2).cHist)

