
% This program compares the solution to the case with learning and pi=0 or
% 1 with the solution to the case without learning.
close all
clc
clear all

CompStr=computer;
switch CompStr

case 'PCWIN'

BaseDirectory='C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\';
SL='\';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/Project Robust Learning/Matlab/InfiniteHorizon/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/ProjectRobustLearning/InfiniteHorizon/';

SL='/';
end

CompEconPath=[BaseDirectory 'compecon2011' SL 'CEtools' SL];
PlotPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Plots' SL];
TexPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Tex' SL];
DataPath=[BaseDirectory 'Learning' SL 'Persistent' SL 'Data' SL];
NoLearningPath=[BaseDirectory];
LearningPath=[BaseDirectory 'Learning' SL];


addpath(genpath(CompEconPath));

Para.m=2;
CoeffFileName=['CoeffRU_NL_' int2str(Para.m) '.mat'];
FSpaceFileName=['QNL_' int2str(Para.m) '.mat'];
load(CoeffFileName)
load(FSpaceFileName)
citer=load( ['C_25.mat']);
Para=citer.Para;
VGrid=citer.VGrid;
c(1,:)=coeff(1,:);
c(2,:)=coeff(1,:);
c(3,:)=coeff(2,:);
c(4,:)=coeff(2,:);
z=1

ComputeAlpha=function(@ [v] )
fplot(@(v) funeval(c(z,:)',Q(z),v) ,[min(VGrid(z,:)),max(VGrid(z,:))])
 
 load( [Para.DataPath 'C_100.mat']);
 z=1
 hold on
fplot(@(v) funeval(c(z,:)',Q(z),[.5 v]) ,[min(VGrid(z,:)),max(VGrid(z,:))])
 
 
