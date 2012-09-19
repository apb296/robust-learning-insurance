% This program compares the solution to the case with learning and pi=0 or
% 1 with the solution to the case without learning.
close all
clc
clear all

CompStr=computer;
switch CompStr

case 'PCWIN'

BaseDirectory='C:\Users\anmol\Dropbox\ProjectRobustLearning\Matlab\InfiniteHoriyon\';
SL='\';
case 'GLNX86'

BaseDirectory='/home/anmol/Dropbox/ProjectRobustLearning/Matlab/InfiniteHoriyon/';
SL='/';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/ProjectRobustLearning/Matlab/InfiniteHoriyon/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/ProjectRobustLearning/InfiniteHoriyon/';

SL='/';
end

CompEconPath=[BaseDirectory 'compecon2011' SL 'CEtools' SL];
PlotPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Plots' SL];
TexPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Tex' SL];
DataPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Data' SL];
NoLearningPath=[BaseDirectory];
LearningPath=[BaseDirectory 'Learning' SL];



addpath(genpath(CompEconPath));
load(['Data/C_29.mat'])

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
% Fig 1 : y=1
% CAPTION : This figure plots the gross change in consumption shares as a function 
%of the initial promized value to Agent 2 given $y(y)=y_l$. The solid (dotted) line refers to
% $y(y^*)=y_l (y_h)$. 


