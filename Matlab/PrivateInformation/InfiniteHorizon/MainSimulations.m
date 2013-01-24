load (['Data/' Para.StoreFileName])

% number of startng points
K=3;
% vLow vMed vHigh
z=1;
TargetConsumption(1)=.10*Para.y;
vHigh=fzero(@(v) ResMapConsumptionToValue(TargetConsumption(1),v,c,Q,Para,domain,PolicyRulesStore,z) ,[min(domain),max(domain)]);
TargeConsumption(2)=.5*Para.y;
vMed=fzero(@(v) ResMapConsumptionToValue(TargeConsumption(2),v,c,Q,Para,domain,PolicyRulesStore,z) ,[min(domain),max(domain)]);
TargeConsumption(3)=(1-Para.Delta)*Para.y;
%vLow=fzero(@(v) ResMapConsumptionToValue(TargeConsumption(3),v,c,Q,Para,domain,PolicyRulesStore,z) ,[min(domain),max(domain)]);

v0=[domain(end) vMed domain(1)];
% NumSim
if matlabpool('size')>0
matlabpool close force local
end
matlabpool open local

parfor k=1:K
    tic
    SimData(k)=RunSimulations(v0(k),rHist,NumSim,c,Q,domain,PolicyRulesStore,Para);
    toc
end

save(['Data/Sim' Para.StoreFileName],'rHist','SimData','TargetConsumption','K','NumSim','Para','Q','c','domain','PolicyRulesStore')
