% RunMain

% First run with a sparse grid to get good initial guess for the value function
SetParaStruc;
addpath(genpath([BaseDirectory SL 'compecon2011']))
Para.NIter=100;
Para.MaxGridAdjustment=0.985;
%MainSurvival(Para);
load('Data/FinalC.mat')
save('Data/FinalCAmbSparse.mat', 'c','Para','Q','VGrid','cdiff','PolicyRules','x_state');

InitData=load(['Data/FinalC.mat']);
% Now we re-interpolate the value function on a finer grid with more splines
OrderOfApproximationV=25;
NIter=100;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.NIter=NIter;
Para.MaxGridAdjustment=0.985;
%MainSurvival(Para);

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
        matlabpool close force local
    end
    
    matlabpool open local;
    
end
load('Data/FinalCAmb.mat')
y_draw0=1;
InitData=load('Data/FinalCAmb.mat');
ConsRatioLow=0.2;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioLow));
VHigh=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioLow,InitData),InitData.x_state(indx,2));

ConsRatioMed=0.5;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioMed));
VMed=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioMed,InitData),InitData.x_state(indx,2));


ConsRatioHigh=0.8;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioHigh));
VLow=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioHigh,InitData),InitData.x_state(indx,2));

InitialV=[VHigh VMed VLow];
%InitialV=[VHigh VLow];
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
Para.MaxGridAdjustment=1;
Para.NIter=100;
Para.theta_1=theta_1*100000000;
Para.theta_2=theta_2*100000000;
MainSurvival(Para);
InitData=load(['Data/FinalC.mat']);
OrderOfApproximationV=25;
NIter=100;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.NIter=NIter;
Para.MaxGridAdjustment=1;
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
        matlabpool close force local
    end
    
    matlabpool open local;
    
end


y_draw0=1;
InitData=load('Data/FinalCNoAmb.mat');
ConsRatioLow=0.2;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioLow));
VHigh=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioLow,InitData),InitData.x_state(indx,2));

ConsRatioMed=0.5;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioMed));
VMed=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioMed,InitData),InitData.x_state(indx,2));


ConsRatioHigh=0.8;
[val,indx]=min(abs((InitData.PolicyRules(:,1)./InitData.Para.Y(InitData.x_state(:,1)))-ConsRatioHigh));
VLow=fzero(@(v) GetValueFromTargetConsumption(v,y_draw0,ConsRatioHigh,InitData),InitData.x_state(indx,2));

InitialV=[VHigh VMed VLow];
%InitialV=[VHigh VLow]

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
Para.N=50000;
Para.WeightP2=.5;
parfor ex=1:length(Experiment)
[yHist(:,ex),VHist(:,ex),ConsRatioAgent1Hist(:,ex),Emlogm_distmarg_agent1Hist(:,ex),Emlogm_distmarg_agent2Hist(:,ex),MPRHist(:,ex)]=SimulateV(Experiment(ex).y_draw,Experiment(ex).V0,Para,c,Q,x_state,PolicyRules,Experiment(ex).DGP);
end
save('Data/SimDataNoAmb.mat' ,'yHist'  ,'VHist', 'ConsRatioAgent1Hist','Emlogm_distmarg_agent1Hist','Emlogm_distmarg_agent2Hist','MPRHist','Para')






%PlotSimulationOutcomes;