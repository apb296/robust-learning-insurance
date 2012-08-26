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
flagOverrideInitialCheck=1;
%ComputeRU_alpha(.2,1,.3,Para)

% Grid for State-Space
disp('building grid begin.....')
tic
BuildGrid;
toc
disp('building grid done.....')
disp('Initializing Coeffecients begin.....')
flagOverrideInitialCheck=1;

InitializeC;

disp('Initializing Coeffecients done.....')



for i=1:NIter
    disp('Starting Iteration No')
    disp(i)
   
    tic
 parfor z=1:Para.ZSize
 %     for z=1:Para.ZSize
        


         [cNew(z,:) res(z,:,:)]= ParallelCoeff(z,c,Q,x0,Para);
     end
    cOld=c;
    
    c=cOld*(1-grelax)+cNew*grelax;
    cdiff(i,:)=sum(abs(cOld-c));
    %
    %
    toc
    %
save( [Para.DataPath 'C_' num2str(i) '.mat'], 'c','Para','x0','Q' ,'res');   
clear res;
end

save( [Para.DataPath 'FinalC.mat'], 'c','Para','x0' , 'Q','cdiff');
    TestValueFunctionLearning;
  


%flagOverrideInitialCheck=1;
%EstimateVStar
m_draw(1)=1;
SimulateV
m_draw(1)=2;
SimulateV
close all
