% RunMain
SetParaStruc;
Para.NIter=50;
MainSurvival(Para);
InitData=load(['Data/C_' num2str(Para.NIter) '.mat']);

OrderOfApproximationV=25;
NIter=50;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.NIter=NIter;
MainSurvival(Para,InitData);

InitData=load(['Data/C_' num2str(Para.NIter) '.mat']);
OrderOfApproximationV=30;
NIter=75;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.NIter=NIter;
MainSurvival(Para,InitData);

load('Data/FinalC.mat')
save('Data/FinalCAmb.mat', 'c','Para','Q','VGrid','cdiff','PolicyRules','x_state');
clear all










%% Set the Parallel Config
err=[];
try
    matlabpool size
    
catch err
end
if isempty(err)
    
    
    if(matlabpool('size') > 0)
        matlabpool close
    end
    
    matlabpool open local;
    
end
load('Data/FinalCAmb.mat')
y_draw0=1;
InitData=load('Data/FinalCAmb.mat');
ConsRatioLow=0.25;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioLow));
VHigh=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioLow,InitData),InitData.x_state(indx,2));

ConsRatioMed=0.5;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioMed));
VMed=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioMed,InitData),InitData.x_state(indx,2));


ConsRatioHigh=0.75;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioHigh));
VLow=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioHigh,InitData),InitData.x_state(indx,2));

InitialV=[VHigh VMed VLow];
ex=1;
DGP=[];
DGP{1}='RefModelAgent1';
DGP{2}='RefModelAgent2';
DGP{3}='DistModelAgent1';
DGP{4}='DistModelAgent2';
for vstart_indx=1:length(InitialV)
    for dgp_indx=1:length(DGP)
    Experiment(ex).V0=InitialV(vstart_indx);
    Experiment(ex).DGP=DGP{dgp_indx};
    Experiment(ex).y_draw=y_draw0;
    ex=ex+1;
    end
end

Para.WeightP2=.5;
Para.N=50000;
parfor ex=1:length(Experiment)
[yHist(:,ex),VHist(:,ex),ConsRatioAgent1Hist(:,ex),Emlogm_distmarg_agent1Hist(:,ex),Emlogm_distmarg_agent2Hist(:,ex),MPRHist(:,ex)]=SimulateV(Experiment(ex).y_draw,Experiment(ex).V0,Para,c,Q,x_state,PolicyRules,Experiment(ex).DGP);
end
save('Data/SimDataAmb.mat' ,'yHist'  ,'VHist', 'ConsRatioAgent1Hist','Emlogm_distmarg_agent1Hist','Emlogm_distmarg_agent2Hist','MPRHist','Para')



% -- NO AMBIBUITY
clear all;
SetParaStruc;
Para.NIter=50;
Para.theta_1=theta_1*10000000;
Para.theta_2=theta_2*10000000;
MainSurvival(Para);
InitData=load(['Data/C_' num2str(Para.NIter) '.mat']);
OrderOfApproximationV=25;
NIter=100;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.NIter=NIter;
MainSurvival(Para,InitData);


load('Data/FinalC.mat')
save('Data/FinalCNoAmb.mat', 'c','Para','Q','VGrid','cdiff','PolicyRules','x_state');
clear all

load('Data/FinalCNoAmb.mat')
%% Set the Parallel Config
err=[];
try
    matlabpool size
    
catch err
end
if isempty(err)
    
    
    if(matlabpool('size') > 0)
        matlabpool close
    end
    
    matlabpool open local;
    
end


y_draw0=1;
InitData=load('Data/FinalCNoAmb.mat');
ConsRatioLow=0.25;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioLow));
VHigh=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioLow,InitData),InitData.x_state(indx,2));

ConsRatioMed=0.5;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioMed));
VMed=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioMed,InitData),InitData.x_state(indx,2));


ConsRatioHigh=0.75;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioHigh));
VLow=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioHigh,InitData),InitData.x_state(indx,2));

InitialV=[VHigh VMed VLow];
ex=1;
DGP=[];
DGP{1}='RefModelAgent1';
DGP{2}='RefModelAgent2';
DGP{3}='DistModelAgent1';
DGP{4}='DistModelAgent2';
load('Data/SimDataAmb.mat')
for vstart_indx=1:length(InitialV)
    for dgp_indx=1:length(DGP)
    Experiment(ex).V0=InitialV(vstart_indx);
    Experiment(ex).DGP=DGP{dgp_indx};
    Experiment(ex).y_draw=yHist(:,ex);
    ex=ex+1;
    end
end
Para.N=50000;
Para.WeightP2=.5;
y_draw=yHist;
parfor ex=1:length(Experiment)
[yHist(:,ex),VHist(:,ex),ConsRatioAgent1Hist(:,ex),Emlogm_distmarg_agent1Hist(:,ex),Emlogm_distmarg_agent2Hist(:,ex),MPRHist(:,ex)]=SimulateV(Experiment(ex).y_draw,Experiment(ex).V0,Para,c,Q,x_state,PolicyRules,Experiment(ex).DGP);
end
save('Data/SimDataNoAmb.mat' ,'yHist'  ,'VHist', 'ConsRatioAgent1Hist','Emlogm_distmarg_agent1Hist','Emlogm_distmarg_agent2Hist','MPRHist','Para')






%PlotSimulationOutcomes;