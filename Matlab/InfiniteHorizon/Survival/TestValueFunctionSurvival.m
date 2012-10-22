% This program compares the solution to the case with learning and pi=0 or
% 1 with the solution to the case without learning.
clear all
close all
clc

SetParaStruc;
addpath(genpath([BaseDirectory SL 'compecon2011']))
coeffname='Data/FinalCNoAmb.mat'
%coeffname='Data/FinalCAmbSparse.mat'

DGP{1}='RefModelAgent1';
DGP{2}='RefModelAgent2';
DGP{3}='DistModelAgent1';
DGP{4}='DistModelAgent2';

%coeffname='Data/C_48.mat'
load([coeffname])
Para.P1
VGrid=linspace((max(Q(1).a,Q(2).a)),( min(Q(2).b,Q(1).b)),25);
for y=1:Para.YSize
    tic
    x0=[];

    for v=1:length(VGrid)
        resQNew=getQNew(y,VGrid(v),c,Q,Para,x0);
        QNew(y,v)=resQNew.QNew;
        ErrorInValueApprox(y,v)=(funeval(c(y,:)',Q(y),[VGrid(v)])-QNew(y,v))/(QNew(y,v));
        LambdaStarL(y,v,:)=resQNew.LambdaStarL;
        Lambda(y,v)=resQNew.Lambda;
          Cons(y,v)=resQNew.Cons;
         ConsStarRatio(y,v,:)=resQNew.ConsStarRatio;
         ConsStar(y,v,:)=resQNew.ConsStar./Para.Y';
         ExitFlag(y,v)=resQNew.ExitFlag;
                VStar(y,v,:)=resQNew.VStar;
                DelVStar(y,v,:)=resQNew.VStar-VGrid(v);
        Distfactor1=resQNew.Distfactor1;
        Distfactor2=resQNew.Distfactor2;
Distorted_P_agent1(y,v,:)=Para.P1(y,:).*Distfactor1;                                  % Distorted Beleifs Agent 1
Distorted_P_agent2(y,v,:)=Para.P2(y,:).*Distfactor2;         % Distorted Beleifs Agent 2

for dgp_ind=1:length(DGP)
    dgp=DGP{dgp_ind};
    switch dgp
        case 'RefModelAgent1'
           y_dist=P1(y,:);
        case 'RefModelAgent2'
           y_dist=P2(y,:);
            case 'DistModelAgent1'
            y_dist=P1(y,:).*resQNew.Distfactor1;   
            case 'DistModelAgent2'
            y_dist=P2(y,:).*resQNew.Distfactor2;   
            
    end
   
    Emlogm_distmarg_agent1(y,v,dgp_ind)=sum((squeeze(Distorted_P_agent1(y,v,:))'./y_dist).*log((squeeze(Distorted_P_agent1(y,v,:))'./y_dist)).*y_dist);                   % Relative Entropy for Agent 1
Emlogm_distmarg_agent2(y,v,dgp_ind)=sum((squeeze(Distorted_P_agent2(y,v,:))'./y_dist).*log((squeeze(Distorted_P_agent2(y,v,:))'./y_dist)).*y_dist);                   % Relative Entropy for Agent 1

end

                x0=[Cons(y,v) VStar(y,v,1) VStar(y,v,1)];
       

    end
 
end

figure()
plot(ErrorInValueApprox')
figure()
plot(Lambda(y,:)'+funeval(c(y,:)',Q(y),[VGrid'],1))


VFineGrid=VGrid;
fplot(@(v) funeval(c(1,:)',Q(1),v)-funeval(c(2,:)',Q(2),v),[max(Q(1).a,Q(2).a) min(Q(2).b,Q(1).b)])



figure()
fplot(@(v) funeval(c(1,:)',Q(1),v,1),[Q(1).a Q(1).b])


figure()
fplot(@(v) funeval(c(1,:)',Q(1),v),[Q(1).a Q(1).b])

figure()
fplot(@(v) funeval(c(1,:)',Q(1),v,2),[Q(1).a Q(1).b])

figure()
plot(VGrid(1,:),log((squeeze(LambdaStarL(1,:,:)))))

figure()
plot(Lambda(1,:),log((squeeze(LambdaStarL(1,:,:)))))
figure()
plot(VGrid(1,:),log((squeeze(LambdaStarL(1,:,:)))))


figure()
subplot(1,2,1)
plot(VGrid(1,:),((squeeze(VStar(1,:,:))))-[VGrid(1,:)' VGrid(1,:)'])

plot(Lambda(1,:),(squeeze(ConsStar(1,:,:))))


InitData=load([coeffname]);
y=1
v=InitData.Para.VMax(y)*1.01
resQNew=getQNew(y,v,InitData.c,InitData.Q,InitData.Para,GetInitalPolicyApprox([y v],InitData.x_state,InitData.PolicyRules))
resQNew.ConsStar./Para.Y'
Para.P1(y,:).*resQNew.Distfactor1
Para.P2(y,:).*resQNew.Distfactor2

figure()
fplot(@(v) funeval(c(1,:)',Q(1),v),[x_state(end-8,2) x_state(end-2,2)])
funeval(c(y,:)',Q(y),[Para.VMax(y)*1.02])