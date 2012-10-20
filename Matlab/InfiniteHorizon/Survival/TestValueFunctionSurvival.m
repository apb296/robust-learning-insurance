% This program compares the solution to the case with learning and pi=0 or
% 1 with the solution to the case without learning.
close all
clc
clear all

SetParaStruc;
addpath(genpath([BaseDirectory SL 'compecon2011']))
coeffname='Data/FinalC.mat'
load([coeffname])
Para.P1
VGrid=Para.VGrid;
for y=1:Para.YSize
    tic
    x0=[];

    for v=1:Para.VGridSize
        resQNew=getQNew(y,VGrid(y,v),c,Q,Para,x0);
        QNew(y,v)=resQNew.QNew;
        LambdaStarL(y,v,:)=resQNew.LambdaStarL;
        Lambda(y,v)=resQNew.Lambda;
          Cons(y,v)=resQNew.Cons;
         ConsStarRatio(y,v,:)=resQNew.ConsStarRatio;
         ConsStar(y,v,:)=resQNew.ConsStar./Para.Y';
         ExitFlag(y,v)=resQNew.ExitFlag;
                VStar(y,v,:)=resQNew.VStar;
                DelVStar(y,v,:)=resQNew.VStar-VGrid(y,v);
        x0=[Cons(y,v) VStar(y,v,1) VStar(y,v,1)];
       

    end
 
end
VFineGrid=VGrid;
fplot(@(v) funeval(c(1,:)',Q(1),v),[Q(1).a Q(1).b])
figure()
fplot(@(v) funeval(c(1,:)',Q(1),v),[0 1])



figure()
fplot(@(v) funeval(c(1,:)',Q(1),v,1),[Q(1).a Q(1).b])


figure()
fplot(@(v) funeval(c(1,:)',Q(1),v),[Q(1).a Q(1).b])

figure()
fplot(@(v) funeval(c(1,:)',Q(1),v,2),[0 15])

figure()
plot(VGrid(1,:),log((squeeze(LambdaStarL(1,:,:)))))

figure()
plot(VGrid(1,:),((squeeze(VStar(1,:,:))))-[VGrid(1,:)' VGrid(1,:)'])

hold on
plot(Lambda(1,:),(squeeze(ConsStar(1,:,:))))


InitData=load([coeffname]);
y=2
v=InitData.Para.VGrid(y,end-3)
resQNew=getQNew(y,v,InitData.c,InitData.Q,InitData.Para,GetInitalPolicyApprox([y v],InitData.x_state,InitData.PolicyRules))
resQNew.ConsStar
Para.P1(y,:).*resQNew.Distfactor1
Para.P2(y,:).*resQNew.Distfactor2

figure()
fplot(@(v) funeval(c(1,:)',Q(1),v),[x_state(end-8,2) x_state(end-2,2)])
