% RunMain
SetParaStruc;
MainSurvival(Para);
DGP{1}='RefModelAgent1';
DGP{2}='RefModelAgent2';
DGP{3}='DistModelAgent1';
DGP{4}='DistModelAgent2';
Para.N=10000;
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

y0=1;
V0=mean(VGrid(y0,:))*.5;
parfor dgp_ind=1:4
[ydraw(:,dgp_ind) V(:,dgp_ind)]=SimulateV(y0,V0,Para,c,Q,x_state,PolicyRules,DGP{dgp_ind});
end

save(['Data/SimData.mat'] ,'y_draw'  ,'V', 'Para')
