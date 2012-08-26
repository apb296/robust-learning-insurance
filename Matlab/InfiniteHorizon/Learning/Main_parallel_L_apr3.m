% This solves the infinite horizon no learning case
clc
clear all
close all
matlabpool close force local
matlabpool local 2
%SetParaStruc;
SetParaStruc_p_learning;
warning off all
%cd(Para.NoLearningPath)
% m_true=1;
% Main_NL(m_true,Para.LearningPath)
% m_true=2;
% Main_NL(m_true,Para.LearningPath)
 
%cd(Para.LearningPath)
% Parameters for the Model

disp('set para struc done.....')
flagOverrideInitialCheck=0;
%ComputeRU_alpha(.2,1,.3,Para)

% Grid for State-Space
disp('building grid begin.....')
tic
BuildGrid;
toc
disp('building grid done.....')
disp('Initializing Coeffecients begin.....')
flagOverrideInitialCheck=0;

InitializeC;

disp('Initializing Coeffecients done.....')

zSlice=x_state(:,1);
PiSlice=x_state(:,2);
vSlice=x_state(:,3);

%citer=load( [Para.DataPath 'C_23.mat']);
%c=citer.c;

for i=1:NIter
    disp('Starting Iteration No')
    disp(i)
   
    tic
 parfor GridInd=1:Para.GridSize
     %for GridInd=1:Para.GridSize
 %     for z=1:Para.ZSize
        z=zSlice(GridInd);
        v=vSlice(GridInd);
        pi=PiSlice(GridInd);
xInit=PolicyRules(GridInd,:);
resQNew=getQNew(z,pi,v,c,Q,Para,xInit);
QNew(GridInd)=resQNew.Q;
PolicyRules(GridInd,:)=[resQNew.Cons resQNew.VStar];
ExitFlag(GridInd,:)=resQNew.ExitFlag;
 res(GridInd)=resQNew;

%clear res;
     end
UpdateValueFunction
     cdiff(i,:)=sum(abs(cOld-c));
     toc
save( [Para.DataPath 'C_' num2str(i) '.mat'], 'c','Para','x0','Q' ,'res','PolicyRules','x_state');   

end
save( [Para.DataPath 'FinalC.mat'], 'c','Para','x0' , 'Q','cdiff');
    TestValueFunctionLearning;
  


%flagOverrideInitialCheck=1;

