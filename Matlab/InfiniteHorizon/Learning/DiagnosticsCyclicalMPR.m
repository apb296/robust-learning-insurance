% This script tries to inverstigate the cylical properties of MPR
 clc
clear all
load Data/theta_1_infty/Transitory/FinalC.mat
pi=.9;
vind=3;
VGrid=Para.VGrid;
    
for z=1:4
    EffProb=pi*Para.P(z,:,1)+(1-pi)*Para.P(z,:,2);   

xInit=GetInitalPolicyApprox([z pi VGrid(z,vind)],x_state,PolicyRules);
resQNew=getQNew(z,pi,VGrid(z,vind),c,Q,Para,xInit);
LambdaStar(z,:)=resQNew.ConsStarRatio'
distpi(z,:)=resQNew.DistPi_agent1;
DistMixture(z,:)=[resQNew.DistPi_agent1 1-resQNew.DistPi_agent1]*resQNew.DistP_agent1';
ReferenceMixture(z,:)=EffProb;
testMPR(z)=resQNew.MPR;
LogLik(z,:)=resQNew.DistMarg_agent_2./EffProb;
testZeta(z,:)=resQNew.Zeta;

end
CompressedDistMixtureTemp=[ DistMixture(:,1)+DistMixture(:,2) DistMixture(:,3)+DistMixture(:,4)];
CompressedDistMixture=CompressedDistMixtureTemp([1 3],:)
CompressedReferenceMixtureTemp=[ ReferenceMixture(:,1)+ReferenceMixture(:,2) ReferenceMixture(:,3)+ReferenceMixture(:,4)];
CompressedReferenceMixture=CompressedReferenceMixtureTemp([1 3],:)
sum(CompressedReferenceMixture.*log(CompressedDistMixture),2)



sum(distpi)/2



clear all
% a sudo example for understading cyclical mpr with learning
piGridSize=5;
piGrid=linspace(0,1,piGridSize)
piGrid=.5
piGridSize=length(piGrid);
pitildlowgridsize=10;
pitildscatter=[]
for piind=1:piGridSize
    pitildelowGrid=linspace(0.1,piGrid(piind)*.99,pitildlowgridsize);

    for pilowind=1:pitildlowgridsize        
ptildehigh(piind,pilowind)=min(fsolve(@(x) ResMPRHighLow(x,piGrid(piind),pitildelowGrid(pilowind)) ,[piGrid(piind)]),1);
pitildscatter=[pitildscatter; pitildelowGrid(pilowind)  ptildehigh(piind,pilowind)];
    end
end
close all
pitildscatter(:,1)+pitildscatter(:,2)-2*piGrid
pi=.95
pilow=pi*.95
ResMPRHighLow(pi,pi,pilow)
ResMPRHighLow(.9999,pi,pilow)

piGridSize=5;
piGrid=linspace(0.001,.9999,piGridSize)
Test=[]
PIID=[.5 .5 ;.5 .5];
PNonIID=[.9 .1 ;.1 .9];
for piind=1:piGridSize
    pitildelowGrid=linspace(piGrid(piind)*0.001,piGrid(piind)*.99,pitildlowgridsize);
    for pilowind=1:pitildlowgridsize
        pi=piGrid(piind);
        pilow=pitildelowGrid(pilowind);
        pihighlim=min(max(2*pi-pilow,0.0001),.9999)
Test=[Test ;ResMPRHighLow(pihighlim,pi,pilow,PIID,PNonIID)];
    end
end
if isempty(find(Test<0))
    disp('sufficient constraint satisfied')
else
    disp('sufficient constraint notsatisfied')
end

pi=0.01
pilow=.0001
ResMPRHighLow(min(max(2*pi-pilow,0.001),.999),pi,pilow)

dist_pi_low= pi*distfactorlow; % distorted mixture probability in we have a recession
dist_pi_high=pi*x(1); % distorted mixture probability in we have a boom


% low state
EffProb=pi.*PIID(1,:)+(1-pi)*PNonIID(1,:);
DistProb=dist_pi_low.*PIID(1,:)+(1-dist_pi_low)*PNonIID(1,:);
logmlow=log(DistProb./EffProb);
Elogm_low=sum(logmlow.*EffProb);
Elog2m_low=sum(EffProb.*log((DistProb./EffProb)).^2);
VarELogMlow=sqrt(Elog2m_low-(Elogm_low)^2)


% highstate
EffProb=pi.*PIID(2,:)+(1-pi)*PNonIID(2,:);
DistProb=dist_pi_high.*PIID(2,:)+(1-dist_pi_high)*PNonIID(2,:);
logmhigh=log(DistProb./EffProb);
Elogm_high=sum(logmhigh.*EffProb);
Elog2m_high=sum(EffProb.*log(DistProb./EffProb).^2);
VarELogMhigh=sqrt(Elog2m_high-(Elogm_high)^2)

res=VarELogMlow-VarELogMhigh;
