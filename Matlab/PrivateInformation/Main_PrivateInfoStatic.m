% This file computes the consumption plan for a static economy
%%%

% TO DO
% 1. Write the code that uses the theta1,theta2 and P as in rest of the
% paper
% 2. Document this program
%%%
clear all
close all
clc
% Paramters
y=10;
Para.y=y;
Delta=.3*y;
Para.Delta=Delta;
lambda=.5;
Para.lambda=lambda;
beta=.5;
Para.beta=beta;
P=[beta 1-beta;1-beta beta];
Para.P=P;
ra=.5;
Para.ra=ra;
cMin=.01*y;
cMax=(y-Delta)*.98;
cGridSize=50;
cGrid=linspace(cMin,cMax,cGridSize);
Para.cGrid=cGrid;
Para.theta=1;
C{1}='k';
C{2}='r';
Para.cMin=cMin;
Para.cMax=cMax;
DeltaMin=.01;
DeltaMax=.3;
DeltaGridSize=25;
DeltaGrid=linspace(DeltaMin,DeltaMax,DeltaGridSize);
lambdaMin=1/3;
lambdaMax=1/lambdaMin;
lambdaGridSize=15;
lambdaGrid=linspace(lambdaMin,lambdaMax,lambdaGridSize);
%lambdaGrid=[.5 1 2 3 4]
%lambdaGridSize=length(lambdaGrid)
thetaMin=1;
thetaMax=10000000;
thetaGridSize=2;
thetaGrid=linspace(thetaMin,thetaMax,thetaGridSize);
Para.PlotPath=[pwd '\Plots\'];
%barc=fzero(@(c) res_barc_static(c,Para),[]);

z0=1;

for theta_ind=1:thetaGridSize

for lambda_ind=1:lambdaGridSize


 lambda=lambdaGrid(lambda_ind);
    theta=thetaGrid(theta_ind);
    Para.lambda=lambda;
    Para.theta=theta;
c(theta_ind,lambda_ind) = fzero(@(c) res_c_static(c,z0,Para),[cMin cMax]);

cons=c(theta_ind,lambda_ind) ;
% tilde_p_agent_1
tilde_p_agent_1(1)=P(z0,1)*exp(-u(cons,ra)/theta);
tilde_p_agent_1(2)=P(z0,2)*exp(-u(cons+Delta,ra)/theta);
tilde_p_agent_1_gr(theta_ind,lambda_ind,:)=tilde_p_agent_1./sum(tilde_p_agent_1);


% tilde_p_agent_2
tilde_p_agent_2(1)=P(z0,1)*exp(-u(y-cons,ra)/theta);
tilde_p_agent_2(2)=P(z0,2)*exp(-u(y-cons-Delta,ra)/theta);
tilde_p_agent_2_gr(theta_ind,lambda_ind,:)=tilde_p_agent_2./sum(tilde_p_agent_2);


end
end
CMat=c;

CMat
[lambdaGrid; tilde_p_agent_1_gr(1,:,1); tilde_p_agent_2_gr(1,:,1);tilde_p_agent_1_gr(1,:,1)./(1-tilde_p_agent_2_gr(1,:,1));CMat(1,:)-CMat(2,:)]'
figure()
%plot(lambdaGrid,barc*ones(lambdaGridSize))
hold on
%subplot(1,2,1)
plot(lambdaGrid,c(1,:),'Color','k')
%title(lambdaGrid(1))
hold on
%subplot(1,2,2)
plot(lambdaGrid,c(2,:),':k')
xlabel('$\lambda$','Interpreter','Latex')
ylabel('$\mathcal{C}^1(z^*_1)$','Interpreter','Latex')
Para.theta=1;
print(gcf,'-dpng',[Para.PlotPath 'StaticPIConsumptionPlan.png']);
 %lambdabar=fzero(@(lambda) F_lambda_bar(lambda,z0,Para),[lambdaMin lambdaMax]);

for lambda_ind=1:lambdaGridSize


 lambda=lambdaGrid(lambda_ind);
   
   
Flambdabar(lambda_ind,:)=F_lambda_bar(lambda,z0,Para);

end
figure()
plot(lambdaGrid,Flambdabar)
hold on
%plot(lambdabar*ones(lambdaGridSize,1),linspace(-max(Flambdabar),max(Flambdabar),lambdaGridSize),':k')



thetaMin=1;
thetaMax=10;
thetaGridSize=15;
thetaGrid=linspace(thetaMin,thetaMax,thetaGridSize);


lambdaMin=.5;
lambdaMax=2;
lambdaGridSize=2;
lambdaGrid=linspace(lambdaMin,lambdaMax,lambdaGridSize);


z0=1;
for lambda_ind=1:lambdaGridSize

for theta_ind=1:thetaGridSize
    lambda=lambdaGrid(lambda_ind);
    theta=thetaGrid(theta_ind);
    Para.lambda=lambda;
    Para.theta=theta;
c(theta_ind,lambda_ind) = fzero(@(c) res_c_static(c,z0,Para),[cMin cMax]);



% tilde_p_agent_1(1)=P(z0,1)*exp(-u(c,ra)/theta);
% tilde_p_agent_1(2)=P(z0,2)*exp(-u(c+Delta,ra)/theta);
% tilde_p_agent_1=tilde_p_agent_1./sum(tilde_p_agent_1);
% 
% 
% % tilde_p_agent_2
% tilde_p_agent_2(1)=P(z0,1)*exp(-u(y-c,ra)/theta);
% tilde_p_agent_2(2)=P(z0,2)*exp(-u(y-c-Delta,ra)/theta);
% tilde_p_agent_2=tilde_p_agent_2./sum(tilde_p_agent_2);

end
end
figure()
subplot(1,2,1)
plot(thetaGrid,c(:,1),'Color','k')
title(lambdaGrid(1))
subplot(1,2,2)
plot(thetaGrid,c(:,2),'Color','r')
title(lambdaGrid(2))

xlabel('$\theta$','Interpreter','Latex')
ylabel('c')
Para.theta=1;

% 
% % for lambda_ind=1:lambdaGridSize
% %     lambda=lambdaGrid(lambda_ind); Para.lambda=lambda;
% % c(lambda_ind) = fzero(@(c) res_c_static(c,z0,Para),[cMin cMax]); end
% % figure() plot(lambdaGrid,c) xlabel('$\lambda$','Interpreter','Latex')
% % ylabel('c') Para.lambda=1;
% 
% 
% 
% % for Delta_ind=1:DeltaGridSize
% %     Delta=DeltaGrid(Delta_ind); Para.Delta=Delta*Para.y;
% % c(Delta_ind) = fzero(@(c) res_c_static(c,z0,Para),[cMin cMax]); end
% % figure() plot(DeltaGrid,c) xlabel('$\Delta$','Interpreter','Latex')
% % ylabel('c')
% % 
% % 
% % 
% % 
% % 
% 
% figure()
% for ex=1:2
%     if ex==1
%         theta=10000000;
%     else
%         theta=1;
%     end
%     for c_ind=1:cGridSize
% 
% c=cGrid(c_ind);
% 
% 
% % tilde_p_agent_1
% tilde_p_agent_1(1)=P(z0,1)*exp(-u(c,ra)/theta);
% tilde_p_agent_1(2)=P(z0,2)*exp(-u(c+Delta,ra)/theta);
% tilde_p_agent_1=tilde_p_agent_1./sum(tilde_p_agent_1);
% 
% 
% % tilde_p_agent_2
% tilde_p_agent_2(1)=P(z0,1)*exp(-u(y-c,ra)/theta);
% tilde_p_agent_2(2)=P(z0,2)*exp(-u(y-c-Delta,ra)/theta);
% tilde_p_agent_2=tilde_p_agent_2./sum(tilde_p_agent_2);
% 
% 
% % LHS
% 
% Num=tilde_p_agent_1(z0,1)*der_u(c,ra)-lambda*tilde_p_agent_2(z0,1)*der_u(y-c,ra);
% Den=tilde_p_agent_1(z0,2)*der_u(c+Delta,ra)-lambda*tilde_p_agent_2(z0,2)*der_u(y-c-Delta,ra);
% LHS(c_ind)=Num;
% 
% 
% 
% % RHS
% 
% RHS(c_ind)=-Den;
%     end
%    
% 
% % Equilibrium c(z_1) subplot(3,1,1) plot(cGrid,LHS,'Color',C{ex})
% % legend('BM','AMb') hold on subplot(3,1,2) plot(cGrid,RHS,'Color',C{ex})
% % hold on subplot(3,1,3)
% 
% plot(cGrid,[RHS' LHS'] ,'Color',C{ex})
% hold on
% end
% 
% lambda=1/lambda;
% figure()
% for ex=1:2
%     if ex==1
%         theta=10000000;
%     else
%         theta=1;
%     end
%     for c_ind=1:cGridSize
% 
% c=cGrid(c_ind);
% 
% 
% % tilde_p_agent_1
% tilde_p_agent_1(1)=P(z0,1)*exp(-u(c,ra)/theta);
% tilde_p_agent_1(2)=P(z0,2)*exp(-u(c+Delta,ra)/theta);
% tilde_p_agent_1=tilde_p_agent_1./sum(tilde_p_agent_1);
% 
% 
% % tilde_p_agent_2
% tilde_p_agent_2(1)=P(z0,1)*exp(-u(y-c,ra)/theta);
% tilde_p_agent_2(2)=P(z0,2)*exp(-u(y-c-Delta,ra)/theta);
% tilde_p_agent_2=tilde_p_agent_2./sum(tilde_p_agent_2);
% 
% 
% % LHS
% 
% Num=tilde_p_agent_1(z0,1)*der_u(c,ra)-lambda*tilde_p_agent_2(z0,1)*der_u(y-c,ra);
% Den=tilde_p_agent_1(z0,2)*der_u(c+Delta,ra)-lambda*tilde_p_agent_2(z0,2)*der_u(y-c-Delta,ra);
% LHS(c_ind)=Num;
% 
% 
% 
% % RHS
% 
% RHS(c_ind)=-Den;
%     end
%    
% x
% % Equilibrium c(z_1) subplot(3,1,1) plot(cGrid,LHS,'Color',C{ex})
% % legend('BM','AMb') hold on subplot(3,1,2) plot(cGrid,RHS,'Color',C{ex})
% % hold on subplot(3,1,3)
% 
% plot(cGrid,[RHS' LHS'] ,'Color',C{ex})
% hold on
% end
% % 
% % 
% 
% %
% % 