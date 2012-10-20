% This program compares the solution to the case with learning and pi=0 or
% 1 with the solution to the case without learning.
close all
clc
clear all

SetParaStruc
addpath(genpath(BaseDirectory));
load(['Data/FinalCSparseAmb.mat'])
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
         ConsStar(y,v,:)=resQNew.ConsStar;
         ExitFlag(y,v)=resQNew.ExitFlag;
                VStar(y,v,:)=resQNew.VStar;
                DelVStar(y,v,:)=resQNew.VStar-VGrid(y,v);
        x0=[Cons(y,v) VStar(y,v,1) VStar(y,v,1)];
       

    end
 
end
VFineGrid=VGrid;
fplot(@(v) funeval(c(1,:)',Q(1),v),[Q(1).a Q(1).b])
