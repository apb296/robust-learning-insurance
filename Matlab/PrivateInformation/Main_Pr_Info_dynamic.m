%% Private Information
% This is the main file to execute the private information economy. I begin
% with the case of no aggregate risk. The agents have either a low
% endowment or a high endowment with a constant aggregate endowment. Denote
% z1 - (ys_l,ys_h) and z2 - (ys_h,ys_l) . Agent 1 has high endowment in z_2
% and vice versa.

clc
clear all
close all
%% Parameters
% This sets up the struture for the paramters and writes a tex file with
% table
SetParaStruc
%y=y*10
%Para.y=y;
sl=.4;
sh=.6;
Para.sl=sl;
Para.sh=sh;
Para.m_true=1;
ra=Para.RA;
RUTheta=ones(2,2);
EUTheta=ones(2,2)*100000000;
P=Para.P(:,:,Para.m_true);
Delta=y*(sh-sl);
Para.Delta=Delta;
Param=[y; sl ; sh; 1-beta(1);1-beta(2) ;Para.RA; Para.delta; Para.Theta(1,1);Para.Theta(1,2)];
rowLabels = {'Agggregate Income ($y$)', 'Low share of Endowment ($s_l$)', 'High share of Endowment ($s_h$)', 'Probability of switching - Model 1 (1-$\beta_1$)','Probability of switching - Model 2 (1-$\beta_2$)','Risk Aversion ($\gamma$)', 'Subjective Discount Factor($\delta$)', 'Ambiguity - Observable State ($\theta_1$)','Ambiguity - Hidden State ($\theta_2$)' };
columnLabels = {'Description', 'Value'};
matrix2latex(Param, [Para.TexPath 'ParamDynamic.tex'] , 'rowLabels', rowLabels, 'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-6.2f', 'size', 'tiny');

%% Grid for initial promised value
z_=1;
c_agent1_min_z1=.01;
c_agent1_min_z2=Delta+.01;

c_agent1_max_z1=y-Delta-.01;
c_agent1_max_z2=y-.01;

c_agent2_min_z1=Delta+.01;
c_agent2_min_z2=.01;
c_agent2_max_z1=y-.01;
c_agent2_max_z2=y-delta-.01;

for z=1:2
vstarmin(z)=P(z,1)*u(y-c_agent1_max_z1,ra)+P(z,2)*u(y-c_agent1_max_z2,ra);


vstarmax(z)=P(z,1)*u(y-c_agent1_min_z1,ra)+P(z,2)*u(y-c_agent1_min_z2,ra);
end


for z=1:2
vstarminRU(z)=-theta21*log(P(z,1)*exp(-u(y-c_agent1_max_z1,ra)/theta21)+P(z,2)*exp(-u(y-c_agent1_max_z2,ra)/theta21));

vstarmaxRU(z)=-theta21*log(P(z,1)*exp(-u(y-c_agent1_min_z1,ra)/theta21)+P(z,2)*exp(-u(y-c_agent1_min_z2,ra)/theta21));
end
Para.vstarRUbounds=[ vstarminRU; vstarmaxRU];


for zTr=1:2
    for zRep=1:2
checkL(zTr,zRep) = fzero(@(cstar) TerminalPKEU(cstar,max(vstarmin),zTr,Para),[.001 (y-Delta-.001)]);
checkH(zTr,zRep) = fzero(@(cstar) TerminalPKEU(cstar,min(vstarmax),zTr,Para),[.001 (y-Delta-.001)]);
    end
end

for z_=1:2
v0Min(z_)=P(z_,1)*(u(c_agent2_min_z1,ra)+delta*vstarmin(1))+P(z_,2)*(u(c_agent2_min_z2,ra)+delta*vstarmin(2));
v0Max(z_)=P(z_,1)*(u(c_agent2_max_z1,ra)+delta*vstarmax(1))+P(z_,2)*(u(c_agent2_max_z2,ra)+delta*vstarmax(2));
VGrid(z_,:)=linspace(v0Min(z_),v0Max(z_),VGridSize);
end
Para.VGrid=VGrid;

% %%
xInit=[y-Delta-3 y-3 u(3+Delta,ra) u(3,ra)];
Para.Theta=Para.Theta;
for z_=1:1
    exitflag=0;
    for v_ind=2:VGridSize-1
   % for v_ind=3:4
tic
       v0=VGrid(z_,v_ind);
       
       vInit=max(min(v0/(1+delta),min(vstarmax)),max(vstarmin));
        cstar0=u_inv(v0-delta*vInit,ra);
        options=optimset('Display','off');
        
        cInit = fzero(@(cstar) TerminalPKEU(cstar,vInit,z_,Para),[.001 (y-Delta-.001)],options);
        
        xInit=[cInit  vInit]; 
             [SimpleContract,fval,exitflatSC] = fsolve(@(x) SimpleContractFOC(x,v0,z_,Para),xInit,options);
  
%     
  % clc     
  alg{1}='interior-point';
  alg{2}='sqp';
%opts = optimset('Algorithm', 'interior-point', 'Display','iter', ... 
opts = optimset('Algorithm', alg{1}, 'Display','off', ...
     'GradObj','on','GradConstr','on',...
     'MaxIter',1000, 'MaxFunEvals',1000);
     %'TolX', Para.ctol, 'TolFun', Para.ctol, 'TolCon', Para.ctol);
  lb=[];
  ub=[];
 % lb=[c_agent1_min_z1 c_agent1_min_z2 max(vstarmin), max(vstarmin)];
 % ub=[c_agent1_max_z1 c_agent1_max_z2 min(vstarmax) min(vstarmax)];
  
 InitContract=[SimpleContract(1) SimpleContract(1)+Delta SimpleContract(2) SimpleContract(2)];
 % DynamicConstraintsEU(InitContract,v0,z_,Para)
Para.Theta=EUTheta;
%  [OptContractEU,fval,exitflagEU,output,MuEU]  =ktrlink(@(x) QEU(x,z_,Para),InitContract,[],[],[],[],lb,ub,@(x) DynamicConstraintsEU(x,v0,z_,Para),opts); 
% [lambdastarEU_1 QstarEU_1 cstarEU_1]=LambdaStar(OptContractEU(3),1,Para,0);
% [lambdastarEU_2 QstarEU_2 cstarEU_2]=LambdaStar(OptContractEU(4),2,Para,0);
% MuEUVal=MuEU.ineqnonlin(2:3)';
% LambdaEUVal=MuEU.eqnonlin';   
% LambdaStarStoreEU(z_,v_ind,:)=[lambdastarEU_1 lambdastarEU_2];
% CStarStoreEU(z_,v_ind,:)=[cstarEU_1 cstarEU_2];
% if exitflagEU ==0
%      exitflagEU=1;
%  else
%      exitflagEU=-3;
%  end
%  

optContract=GetOptimalCpontractUsingFOC(v0,z_,Para,InitContract);
OptContractEU=optContract.Contract;
exitflagEU=optContract.exitflag;
MuEUVal=optContract.mu;
LambdaEUVal=optContract.lambda;
[lambdastarEU_1 QstarEU_1 cstarEU_1]=LambdaStar(OptContractEU(3),1,Para,0);
[lambdastarEU_2 QstarEU_2 cstarEU_2]=LambdaStar(OptContractEU(4),2,Para,0);
LambdaStarStoreEU(z_,v_ind,:)=[lambdastarEU_1 lambdastarEU_2];
CStarStoreEU(z_,v_ind,:)=[cstarEU_1 cstarEU_2];
 InitContract=OptContractEU;
    
Para.Theta=RUTheta;
% [OptContract,fval,exitflag,output,Mu]  =ktrlink(@(x) QRU(x,z_,Para),InitContract,[],[],[],[],lb,ub,@(x) DynamicConstraintsRU(x,v0,z_,Para),opts);
% MuRUVal=Mu.ineqnonlin(2:3)';
% LambdaRUVal=Mu.eqnonlin';   
%  if exitflag ==0
%      exitflagRU=1;
%  else
%      exitflagRU=-3;
%  end
% 
% 

optContract=GetOptimalCpontractUsingFOC(v0,z_,Para,InitContract);
OptContract=optContract.Contract;
exitflagRU=optContract.exitflag;
MuRUVal=optContract.mu;
LambdaRUVal=optContract.lambda;
[lambdastarRU_1 QstarRU_1 cstarRU_1]=LambdaStar(OptContract(3),1,Para,1);
[lambdastarRU_2 QstarRU_2 cstarRU_2]=LambdaStar(OptContract(4),2,Para,1);
LambdaStarStore(z_,v_ind,:)=[lambdastarRU_1 lambdastarRU_2];
CStarStore(z_,v_ind,:)=[cstarRU_1 cstarRU_2];
ExitFlagStore(z_,v_ind,:)=exitflagRU;
ExitFlagStoreEU(z_,v_ind,:)=exitflagEU;
Lambda(z_,v_ind,:)=LambdaRUVal;
LambdaEU(z_,v_ind,:)=LambdaEUVal;
MuStoreEU(z_,v_ind,:)=MuEUVal;
 MuStore(z_,v_ind,:)=MuRUVal;
 OptContractStore(z_,v_ind,:)=OptContract;
 OptContractStoreEU(z_,v_ind,:)=OptContractEU;
 SimpleContractStore(z_,v_ind,:)=[SimpleContract(1) SimpleContract(1)+Delta SimpleContract(2) SimpleContract(2)];
toc
disp(v_ind);

    
    end
    IndxSolved(z_,:)=find(ExitFlagStore(z_,:).*ExitFlagStoreEU(z_,:)==1);
    %IndxSolved(z_,:)=find(ExitFlagStore(z_,:));
    
end

%% fig:1  - Multipliers

% CAPTION : This figure plots the muplitiplier on the binding incentive
% contraint. The red line refers to $\mu^1_2$ - Agent 1 State $z_2$ and the
% black line refers to $\mu^2_1$ - Agent 2 state $z_1$. The dotted line is
% $\tehta=\infty$ case


PlotData=[ -LambdaEU(z_,logical(ExitFlagStoreEU(z_,:)==1)) ;squeeze(MuStoreEU(z_,logical(ExitFlagStoreEU(z_,:)==1),1)) ;squeeze(MuStoreEU(z_,logical(ExitFlagStoreEU(z_,:)==1),2))]';
figure()
plot(PlotData(:,1),PlotData(:,2),'LineWidth',2,'Color','r','LineStyle',':')
hold on
plot(PlotData(:,1),PlotData(:,3),'LineWidth',2,'Color','k','LineStyle',':')
xlabel('$\lambda$','Interpreter','Latex');
ylabel('$\mu^i_z$','Interpreter','Latex');

PlotData=[ -LambdaEU(z_,IndxSolved(z_,:)) ;squeeze(MuStoreEU(z_,IndxSolved(z_,:),1)) ;squeeze(MuStoreEU(z_,IndxSolved(z_,:),2))]';
figure()
plot(PlotData(:,1),PlotData(:,2),'LineWidth',2,'Color','r','LineStyle',':')
hold on
plot(PlotData(:,1),PlotData(:,3),'LineWidth',2,'Color','k','LineStyle',':')
xlabel('$\lambda$','Interpreter','Latex');
ylabel('$\mu^i_z$','Interpreter','Latex');

PlotData=[ -Lambda(z_,IndxSolved(z_,:)) ;squeeze(MuStore(z_,IndxSolved(z_,:),1)) ;squeeze(MuStore(z_,IndxSolved(z_,:),2))]';
plot(PlotData(:,1),PlotData(:,2),'LineWidth',2,'Color','r')
hold on
plot(PlotData(:,1),PlotData(:,3),'LineWidth',2,'Color','k')
xlabel('$\lambda$','Interpreter','Latex');
ylabel('$\mu^i_z$','Interpreter','Latex');
print(gcf,'-dpng',[Para.PlotPath 'BindingMultipliers.png']);


%% fig:2  - Comparing contracts under ambiguity and EU 


% CAPTION : This figure depicts the optimal consumption plan ( risk adjusted expected value ) with model uncertainty. The dotted
% lines correspond to the optimal contract under the EU bennchmark
z_=1;
PlotData=[-Lambda(z_,IndxSolved(z_,:))'  squeeze(OptContractStore(z_,IndxSolved(z_,:),1:2)) -LambdaEU(z_,IndxSolved(z_,:))'  squeeze(OptContractStoreEU(z_,IndxSolved(z_,:),1:2)) ];
figure()
plot(PlotData(:,1),PlotData(:,2:3),'LineWidth',2,'Color','k')
hold on
plot(PlotData(:,4),PlotData(:,5:6),'LineWidth',2,'Color','k','LineStyle',':');
xlabel('$\lambda$','Interpreter','Latex');
ylabel('$c$','Interpreter','Latex');
print(gcf,'-dpng',[Para.PlotPath 'CompOptContractCons.png']);


%% fig:3  - Comparing contracts under ambiguity and EU - lambda&* Plans

% CAPTION : This figure depicts the dynamics of lambda with model uncertainty. The dotted
% lines correspond to the optimal contract under the EU bennchmark

z_=1;
PlotData=[-Lambda(z_,IndxSolved(z_,:))'  squeeze(LambdaStarStore(z_,IndxSolved(z_,:),:)) -LambdaEU(z_,IndxSolved(z_,:))'  squeeze(LambdaStarStoreEU(z_,IndxSolved(z_,:),:)) ];
figure()
plot(PlotData(:,1),PlotData(:,2:3),'LineWidth',2,'Color','k')
hold on
plot(PlotData(:,4),PlotData(:,5:6),'LineWidth',2,'Color','k','LineStyle',':');
xlabel('$\lambda$','Interpreter','Latex');
ylabel('$\lambda^*$','Interpreter','Latex');
print(gcf,'-dpng',[Para.PlotPath 'CompOptContractLambdaStar.png']);


%% fig:4  - Comparing contracts under ambiguity and EU - Consumption

% CAPTION : This figure depicts the terminal how the current consumption
% and future consumption vary

z_=1;
PlotData=[squeeze(OptContractStore(z_,IndxSolved(z_,:),1))'  squeeze(CStarStore(z_,IndxSolved(z_,:),1))' squeeze(OptContractStoreEU(z_,IndxSolved(z_,:),1))'  squeeze(CStarStoreEU(z_,IndxSolved(z_,:),1))'];
figure()
subplot(1,2,1)
plot(PlotData(:,1),PlotData(:,2),'LineWidth',2,'Color','k')
hold on
plot(PlotData(:,3),PlotData(:,4),'LineWidth',2,'Color','k','LineStyle',':');
xlabel('$c$','Interpreter','Latex');
ylabel('$c^*$','Interpreter','Latex');

PlotData=[squeeze(OptContractStore(z_,IndxSolved(z_,:),2))'  squeeze(CStarStore(z_,IndxSolved(z_,:),2))' squeeze(OptContractStoreEU(z_,IndxSolved(z_,:),2))'  squeeze(CStarStoreEU(z_,IndxSolved(z_,:),2))'];
subplot(1,2,2)
plot(PlotData(:,1),PlotData(:,2),'LineWidth',2,'Color','k')
hold on
plot(PlotData(:,3),PlotData(:,4),'LineWidth',2,'Color','k','LineStyle',':');
xlabel('$c$','Interpreter','Latex');
ylabel('$c^*$','Interpreter','Latex');
print(gcf,'-dpng',[Para.PlotPath 'CompOptContractCStar.png']);


%% fig:4  - Comparing contracts under ambiguity and EU - Continuation Plans

% CAPTION : This figure plots the terminal consumption plan as  function of
% lambda. 

z_=1;
PlotData=[-Lambda(z_,IndxSolved(z_,:))'  squeeze(CStarStore(z_,IndxSolved(z_,:),:)) -LambdaEU(z_,IndxSolved(z_,:))'  squeeze(CStarStoreEU(z_,IndxSolved(z_,:),:)) ];
figure()
plot(PlotData(:,1),PlotData(:,2:3),'LineWidth',2,'Color','k')
hold on
plot(PlotData(:,4),PlotData(:,5:6),'LineWidth',2,'Color','k','LineStyle',':');
xlabel('$\lambda$','Interpreter','Latex');
ylabel('$c^*$','Interpreter','Latex');
print(gcf,'-dpng',[Para.PlotPath 'CompOptContractLambdaCStar.png']);




