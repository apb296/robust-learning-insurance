% This program compares the solution to the case with learning and pi=0 or
% 1 with the solution to the case without learning.
close all
clc
clear all
NumTest=20;
flagBenchMark=0;
SetParaStruc_p_learning
OldDataPath=[Para.DataPath 'theta_1_infty' SL 'Transitory' SL];
citer=load( [OldDataPath 'InitialC.mat']);
Para=citer.Para;
Para.DataPath=OldDataPath;
Para.BenchMark=flagBenchMark;
Para.NIter=49;
cold=citer.c;
for i=2:Para.NIter
citer=load( [Para.DataPath 'C_' num2str(i) '.mat']);
c=citer.c;
cdiff=citer.cdiff;
cold=c;
end
Para.PlotPath='tempPlots/';
mkdir(Para.PlotPath);
figure()
plot(cdiff)
xlabel('Number of Iteration')
ylabel('Coeffecients')
title('Convergence of Coeffecients')
print(gcf, '-dpng', [ Para.PlotPath 'Fig_Convergence_Coeff.png'] );
citer=load( [Para.DataPath 'C_' num2str(i) '.mat']);
Para=citer.Para;
Para.BenchMark=flagBenchMark;

Q=citer.Q;
c=citer.c;
PolicyRules=citer.PolicyRules;
x_state=citer.x_state;



PiGridSize=Para.PiGridSize;
VGridSize=Para.VGridSize;
PiGrid=Para.PiGrid;
VGrid=Para.VGrid;
VMin=min(VGrid');
VMax=max(VGrid');
PiMin=min(PiGrid);
PiMax=max(PiGrid);
PiSize=Para.PiGridSize;
res=citer.res;

for i=1:NumTest
z=round(1+rand*3);
pi=PiMin+rand*(PiMax-PiMin);

v=VMin(z)+rand*(VMax(z)-VMin(z));
xtest(i,:)=[z pi v];
xInit=GetInitalPolicyApprox(xtest(i,:),x_state,PolicyRules);
resQNew=getQNew(z,pi,v,c,Q,Para,xInit);
Q1(i)=resQNew.Q;
Q2(i)=funeval(c(z,:)',Q(z),[ pi v]);
ChebError(i)=Q1(i)/Q2(i)-1;
disp(i)
end



[QNew Cons LambdaStar LambdaStarL VStar DelVStar DistPi_agent1 DistPi_agent2 ExitFlag MuCons SigmaCons EntropyMargAgent1 EntropyMargAgent2 PK MPR ConsStar ConsStarRatio MuDelVStar DistMargAgent1 DistMargAgent2]=GetDiagnostics(c,Q,PolicyRules,Para);
Y=Para.Y
VGrid=Para.VGrid;
z=3
zstar=3
pi=.5;
VFineGridSize=50;
VFineGrid=linspace(min(VGrid(z,:)),max(VGrid(z,:)),VFineGridSize)
ConsStarRatio=zeros(VFineGridSize,1);
ExitFlag=zeros(VFineGridSize,1);
for vind=1:VFineGridSize
xInit=GetInitalPolicyApprox([z pi VFineGrid(vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VFineGrid(vind),c,Q,Para,xInit);
ExitFlag(vind)=resQNew.ExitFlag;
ConsStarRatio(vind)=(resQNew.ConsStar(zstar)/(Y(zstar)))/(resQNew.Cons/(Y(z)));
LambdaStarL(vind)=resQNew.LambdaStarL(zstar);
QNew(vind)=resQNew.Q;
end
figure()
plot(VFineGrid(logical(ExitFlag==1)),LambdaStarL(logical(ExitFlag==1)))
figure()
plot(VFineGrid(logical(ExitFlag==1)),ConsStarRatio(logical(ExitFlag==1)))
figure()
plot(VFineGrid(logical(ExitFlag==1)),QNew(logical(ExitFlag==1)))

figure()
for z=1:4

   subplot(2,2,z) 
   InxPrint=find(squeeze(ExitFlag(z,1,:))==1);
   plot(VGrid(z,InxPrint),squeeze(LambdaStarL(z,1,InxPrint,3)),'k')
   hold on
   InxPrint=find(squeeze(ExitFlag(z,end,:))==1);
   plot(VGrid(z,InxPrint),squeeze(LambdaStarL(z,end,InxPrint,3)),'r')
end

%for z=1:Para.ZSize
 %QNL_model2(z,1:VGridSize)=QNL0(z,1:VGridSize);

 %QNL_model1(z,1:VGridSize)=QNL0(z,end-VGridSize+1:end);

    %   for v=1:VGridSize
%     cd(Para.NoLearningPath)
%  cNL_1(1,:)=CoeffRU_NL_1.coeff(1,:);
%  cNL_1(2,:)=CoeffRU_NL_1.coeff(1,:);
%  cNL_1(3,:)=CoeffRU_NL_1.coeff(2,:);
%  cNL_1(4,:)=CoeffRU_NL_1.coeff(2,:);
% Para.m=1;
%  resQNew_1=getQNew(z,VGrid(z,v),cNL_1,QNL_1.Q,Para);
%  Cons_1=resQNew_1.Cons;
%  VStar_1=resQNew_1.VStar;
% QNew_1=funeval(cNL_1(z,:)',QNL_1.Q(z),[VGrid(z,v)]);
%         cd(Para.LearningPath)
%     QNL_model1(z,v)=resQNew_1.QNew;
%    QNL_direct_1(z,v)=QNew_1;
%      QL_direct_1(z,v)=funeval(c(z,:)',Q(z),[1 VGrid(z,v)]);
%         QL_model1(z,v)=QNew(z,PiGridSize,v);
%         QL_model2(z,v)=QNew(z,1,v);
%        DiffCons_model1(z,v)= Cons(z,PiGridSize,v)-x0(z,PiGridSize,v,1);
%        DiffCons_model2(z,v)= Cons(z,1,v)-x0(z,1,v,1);
%         DiffVStar_model1(z,v,:)= sum(VStar(z,PiGridSize,v,:)-x0(z,PiGridSize,v,2:end));
%        DiffVStar_model2(z,v,:)= sum(VStar(z,1,v,:)-x0(z,1,v,2:end)); 
%         
%     end
%     
%     subplot(2,2,z)
%     plot(VGrid(z,:),QNL_model1(z,:),':k')
%      hold on
%     plot(VGrid(z,:),QNL_direct_1(z,:),'k')
% 
%     hold on
%     plot(VGrid(z,:),QL_direct_1(z,:),'r','LineWidth',2)
%      hold on
%     
%    hold on
%   plot(VGrid(z,:),QL_model1(z,:),':r','LineWidth',2)
%     
%  end
%   figure()
%  plot(DiffCons_model1')
%  figure()
%  plot(DiffVStar_model1')
%  

close all
X.Data=(Cons)        ;
X.Name='$C1$';
X.FigName='Cons';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)


close all
X.Data=(QNew)        ;
X.Name='$Q$';
X.FigName='Cons';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)



close all

X.Data=(DelVStar);
X.Name='$\Delta V^*$';
X.FigName='DelVStar';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)
% 
close all
X.Data=(LambdaStarL);
X.Name='$\frac{\lambda^{*}}{\lambda}$';
X.FigName='LambdaStarRatio';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)
% 
% 
close all
X.Data=(LambdaStar);
X.Name='$\lambda^{*}$';
X.FigName='LambdaStar';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)


close all
X.Data=(MPR);
X.Name='MPR';
X.FigName='MPR';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)


close all
X.Data=(ConsStarRatio);
X.Name='$\frac{c^1(z^*)}{c^1(z)}$';
X.FigName='ConsStarRatio';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)


close all
X.Data=(MuDelVStar);
X.Name='$E_z\Delta v^*$';
X.FigName='MuDelVStar';
X.VGrid=[];
X.PiGrid=[];
flag3D=0;
DrawPlot(X,flag3D,Para)
close all
pi_ind=round(PiSize/2);
for z=1:Para.ZSize
    subplot(2,2,z)
plot(VGrid(z,:),squeeze(EntropyMargAgent1(z,pi_ind,:)),'k','LineWidth',2)
hold on
plot(VGrid(z,:),squeeze(EntropyMargAgent2(z,pi_ind,:)),':k','LineWidth',2)
 xlabel([Para.StateName(z)],'Interpreter','LaTex')
   %title(StateName(z),'Interpreter','LaTex')
   ylabel('Ent','Interpreter','LaTex')
   legend('Agent 1','Agent 2')
end
print(gcf, '-dpng', [ Para.PlotPath 'Fig_MarginalEntropy.png'] );

close all
v_ind=VGridSize-2;
pi_ind=round(PiGridSize/2);
for z=1:Para.ZSize
    Eff=PiGrid(pi_ind)*Para.P(z,:,1)+(1-PiGrid(pi_ind))*Para.P(z,:,2);
    PR1(z,:)=squeeze(DistMargAgent1(z,pi_ind,v_ind,:))'./Eff
    PR2(z,:)=squeeze(DistMargAgent2(z,pi_ind,v_ind,:))'./Eff
end
    Eff=PiGrid(pi_ind)*Para.P(1,:,1)+(1-PiGrid(pi_ind))*Para.P(1,:,2);
bar((squeeze(DistMargAgent1(1,pi_ind,:,:))./repmat(Eff,VGridSize,1)))
pcolor(PR1)
colormap(gray)
close all
for z=1:Para.ZSize
    subplot(2,2,z)
    plot(PiGrid,squeeze(DistPi_agent1(z,:,1)),'LineWidth',2,'Color','k')
    hold on
   % plot(PiGrid,squeeze(DistPi_agent2(z,:,1)),'LineWidth',2,'Color','r')
    xlabel('$\pi$','Interpreter','LaTex')
    ylabel('$\tilde{\pi}$','Interpreter','LaTex')
       title(Para.StateName(z),'Interpreter','LaTex')

end
print(gcf, '-dpng', [ Para.PlotPath 'Fig_DistPi.png'] );



close all
for z=1:Para.ZSize
    subplot(2,2,z)
    plot(PiGrid,squeeze(DistPi_agent1(z,:,1))./squeeze(DistPi_agent2(z,:,1)),'LineWidth',2,'Color','k')
    hold on
  %  plot(PiGrid,squeeze(DistPi_agent1(z,:,end))./squeeze(DistPi_agent2(z,:,end)),':k','LineWidth',2)
    xlabel('$\pi$','Interpreter','LaTex')
    ylabel('$\tilde{\pi}$','Interpreter','LaTex')
       title(Para.StateName(z),'Interpreter','LaTex')

end
print(gcf, '-dpng', [ Para.PlotPath 'Fig_DistPiRatio.png'] );


hold off
close all
% Mean Variance Frontier for Consumption
for z=1:Para.ZSize
    subplot(2,2,z)
    %plot(VGrid(z,:),squeeze(Data_Model_1(z,1,:,:)));
    hold on
    plot(squeeze(MuCons(z,1,:)),squeeze(SigmaCons(z,1,:)),'k','LineWidth',2);
    hold on
    plot(squeeze(MuCons(z,(round(PiSize/2)),:)),squeeze(SigmaCons(z,(round(PiSize/2)),:)),':b','LineWidth',2);
    hold on
    plot(squeeze(MuCons(z,end,:)),squeeze(SigmaCons(z,end,:)),'r','LineWidth',2);
    hold on
    
    
   xlabel('Mean Consumption (Agent 1)')
   title(Para.StateName(z),'Interpreter','LaTex')
   ylabel('Vol Consumption (Agent 1)','Interpreter','LaTex')
    end
    print(gcf, '-dpng', [ Para.PlotPath 'Fig_' 'MVF_Cons' '.png'] );


    
    
    
%EstimateVStar
m_draw0=1;
z_draw0=1;
V0=VGrid(z_draw0,2);
pi_bayes0=1;
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Para,c,Q,x_state,PolicyRules)
m_draw0=2;
z_draw0=1;
V0=VGrid(z_draw0,2);
pi_bayes0=0;
SimulateV(m_draw0,z_draw0,V0,pi_bayes0,Para,c,Q,x_state,PolicyRules,BurnSample)%
%% Test sapce

load([DataPath 'theta_1_infty/Transitory/C_49.mat'])
z=1;
pi=.2105;
v=2.1448
xInit=GetInitalPolicyApprox([z pi*.8 v*1.1],x_state,PolicyRules);

resQNew=getQNew(z,pi,v,c,Q,Para,xInit)
