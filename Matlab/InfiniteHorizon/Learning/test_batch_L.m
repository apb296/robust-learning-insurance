% This solves the infinite horizon no learning case
clc
clear all
close all

%matlabpool close force local
%matlabpool local 2
% cd('C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\');
% m_true=1;
% Main_NL
% clear all
% m_true=2;
% Main_NL
% clear all
% cd('C:\Users\anmol\Dropbox\Project Robust Learning\Matlab\InfiniteHorizon\Learning');

%addpath(genpath('/Applications/MATLAB_R2011a_Student.app/toolbox/compecon2011/'))
%matlabpool open

% Parameters for the Model

SetParaStruc;
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
InitializeC;
disp('Initializing Coeffecients done.....')
sched = findResource('scheduler','type','local');
%pjob = createJob(sched);
%createTask(pjob, 'run_iter_parallel', 1, {c,Q,x0,Para})
%createTask(pjob, 'ParallelCoeff', 1, {1,c,Q,x0,Para})
%createTask(pjob, 'ParallelCoeff', 1, {2,c,Q,x0,Para})
% submit(pjob);
% waitForState(pjob);
% out = getAllOutputArguments(pjob);
%destroy(pjob)
tic
r0=run_iter_parallel(c,Q,x0,Para)
toc
  sch = findResource('scheduler', ...
                     'configuration', defaultParallelConfig);
tic
j1= batch(sch , 'run_iter_parallel', 1, {c,Q,x0,Para});          
%j2= batch(sch , 'ParallelCoeff', 1, {1,c,Q,x0,Para});           
%           
     %     destroy(j1)
wait(j1)
 toc
r1 = getAllOutputArguments(j1) % Get results into a cell array

 % % 
% %     tic
% %        j1= batch(sch , 'ParallelCoeff', 1, {1,c,Q,x0,Para});
% % % j2 = batch(sch , 'ParallelCoeff', 1, {2,c,Q,x0,Para});
% % %      j3= batch(sch , 'ParallelCoeff', 1, {3,c,Q,x0,Para});
% % j4 = batch(sch , 'ParallelCoeff', 1, {4,c,Q,x0,Para});
% 
% addpath(genpath(Para.CompEconPath));
%        j1= batch(sch , 'ParallelCoeff', 1, {1,c,Q,x0,Para});
% j2 = batch(sch , 'ParallelCoeff', 1, {2,c,Q,x0,Para});
% 
% wait(j2)
% 
% ParallelCoeff(1,c,Q,x0,Para)
%           %('ParallelCoeff',z,c,Q,x0,Para)
% %         
%       end
%      
%      matlabpool close force local
%        ParallelCoeff(1,c,Q,x0,Para)
   