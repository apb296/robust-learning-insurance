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
OrderOfApproximationV=50;
NIter=75;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.NIter=NIter;
MainSurvival(Para,InitData);


cd Data
system('move FinalC.mat FinalCAmb.mat')
cd ..
load('Data/FinalCAmb.mat')
DGP{1}='RefModelAgent1';
DGP{2}='RefModelAgent2';
DGP{3}='DistModelAgent1';
DGP{4}='DistModelAgent2';
Para.N=20000;
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
V0=mean(Para.VGrid(y_draw0,:))*1.3;
Para.WeightP2=.5;
parfor dgp_ind=1:4
[yHist(:,dgp_ind),VHist(:,dgp_ind),ConsRatioAgent1Hist(:,dgp_ind),Emlogm_distmarg_agent1Hist(:,dgp_ind),Emlogm_distmarg_agent2Hist(:,dgp_ind),MPRHist(:,dgp_ind)]=SimulateV(y_draw0,V0,Para,c,Q,x_state,PolicyRules,DGP{dgp_ind});
end
save(['Data/SimDataAmb.mat'] ,'yHist'  ,'VHist', 'ConsRatioAgent1Hist','Emlogm_distmarg_agent1Hist','Emlogm_distmarg_agent2Hist','MPRHist','Para')



% RunMain
SetParaStruc;
Para.NIter=150;
Para.theta_1=theta_1*10000000;
Para.theta_2=theta_2*10000000;
%MainSurvival(Para);
%cd Data
%system('move FinalC.mat FinalCNoAmb.mat')
%cd ..
load('Data/FinalCNoAmb.mat')
DGP{1}='RefModelAgent1';
DGP{2}='RefModelAgent2';
DGP{3}='DistModelAgent1';
DGP{4}='DistModelAgent2';
Para.N=2000; 
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
V0=mean(Para.VGrid(y_draw0,:))*1.3
Para.WeightP2=.5;
y_draw=yHist;
parfor dgp_ind=1:4
[yHist(:,dgp_ind),VHist(:,dgp_ind),ConsRatioAgent1Hist(:,dgp_ind),Emlogm_distmarg_agent1Hist(:,dgp_ind),Emlogm_distmarg_agent2Hist(:,dgp_ind),MPRHist(:,dgp_ind)]=SimulateV(y_draw(:,dgp_ind),V0,Para,c,Q,x_state,PolicyRules,DGP{dgp_ind});
end
save('Data/SimDataNoAmb.mat' ,'yHist'  ,'VHist', 'ConsRatioAgent1Hist','Emlogm_distmarg_agent1Hist','Emlogm_distmarg_agent2Hist','MPRHist','Para')



%PlotSimulationOutcomes;