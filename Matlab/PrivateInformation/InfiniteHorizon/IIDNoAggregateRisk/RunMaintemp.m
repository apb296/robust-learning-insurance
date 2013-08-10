clear all
close all
SetParaStruc

Para.beta=.9;
Para.ra=.5
Para.y=10; % Aggregate output
Para.sl=.25; % low share
Para.sh=.75; % high share
Para.Delta=Para.y*(Para.sh-Para.sl); % Amount you can stead
Para.Theta=ones(2,2)*.75;
%Para.Theta=ones(2,2)*10000000;
Para.vGridSize=105; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=100; % order of approximation
Para.InitializeDataFile='PrivateInformationAmbtemp.mat';
Para.StoreFileName='PrivateInformationAmbtemp2.mat';
Para.c_offset=.0005*Para.y;  
Para.MaxIter=6
MainBellman(Para)




break

a=5
b=5

%MainSimulationsUsingLinearInterpolation
NoAmbData=load ('Data/PrivateInformationNoAmbtemp.mat')  ;
AmbData=load ('Data/PrivateInformationAmbtemp2.mat')  ;


figure()
subplot(2,1,1)
obj=AmbData;
RealtivePessimism_sh=obj.DistortedBeliefsAgent2Store(:,2)./obj.DistortedBeliefsAgent1Store(:,2)
RealtivePessimism_sl=obj.DistortedBeliefsAgent2Store(:,1)./obj.DistortedBeliefsAgent1Store(:,1)

mu_1_sh=obj.MuStore(:,2)./obj.DistortedBeliefsAgent1Store(:,2);
mu_2_sl=obj.MuStore(:,3)./(obj.DistortedBeliefsAgent2Store(:,1).*obj.LambdaStore(:));

GrowthRate_sh=((1-mu_2_sl.*(obj.DistortedBeliefsAgent2Store(:,1)./obj.DistortedBeliefsAgent2Store(:,2)))./(1+mu_1_sh)).*RealtivePessimism_sh
GrowthRate_sl=((1+mu_2_sl)./(1-mu_1_sh.*(obj.DistortedBeliefsAgent1Store(:,2)./obj.DistortedBeliefsAgent1Store(:,1)))).*RealtivePessimism_sl

plot(LambdaStore(a:end-b),GrowthRate_sh(a:end-b)-1,':k','LineWidth',2)
hold on
plot(LambdaStore(a:end-b),GrowthRate_sl(a:end-b)-1,'k','LineWidth',2)
legend('y_2(s)=y_l','y_2(s)=y_h')
xlabel('$\lambda$','Interpreter','Latex')
ylabel('$\Delta[log(\lambda(s))]$','Interpreter','Latex')
title('$\theta<\infty$','Interpreter','Latex')

subplot(2,1,2)
obj=AmbData;
RealtivePessimism_sh=obj.DistortedBeliefsAgent2Store(:,2)./obj.DistortedBeliefsAgent1Store(:,2)
RealtivePessimism_sl=obj.DistortedBeliefsAgent2Store(:,1)./obj.DistortedBeliefsAgent1Store(:,1)

mu_1_sh=obj.MuStore(:,2)./obj.DistortedBeliefsAgent1Store(:,2);
mu_2_sl=obj.MuStore(:,3)./(obj.DistortedBeliefsAgent2Store(:,1).*obj.LambdaStore(:));

GrowthRate_sh=((1-mu_2_sl.*(obj.DistortedBeliefsAgent2Store(:,1)./obj.DistortedBeliefsAgent2Store(:,2)))./(1+mu_1_sh)).*RealtivePessimism_sh
GrowthRate_sl=((1+mu_2_sl)./(1-mu_1_sh.*(obj.DistortedBeliefsAgent1Store(:,2)./obj.DistortedBeliefsAgent1Store(:,1)))).*RealtivePessimism_sl

plot(LambdaStore(a:end-b),GrowthRate_sh(a:end-b)-1,':r','LineWidth',2)
hold on
plot(LambdaStore(a:end-b),GrowthRate_sl(a:end-b)-1,'r','LineWidth',2)
legend('y_2(s)=y_l','y_2(s)=y_h')
xlabel('$\lambda$','Interpreter','Latex')
ylabel('$\Delta[log(\lambda(s))]$','Interpreter','Latex')
title('$\theta=\infty$','Interpreter','Latex')


vl=u(0,Para.ra)
vh=u(5,Para.ra)

dist_pl=1/(1+exp((vh-vl)/Para.Theta(1)))