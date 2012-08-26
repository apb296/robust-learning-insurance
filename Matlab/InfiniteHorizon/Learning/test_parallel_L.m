% This solves the infinite horizon no learning case
clc
clear all
close all
matlabpool close force local
matlabpool local 2
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
i=1
%for pi=1:PiGridSize
    
   % for v=1:VGridSize
    
       
        
        
                    x(1,:)=[PiGrid(1) VGrid(1,1) squeeze(x0(1,1,1,:))'] ;                  
    %end
%end

% parfor z=1:1
% ParallelCoeff_test(1,c,Q,x,Para)
% end
% ParallelCoeff_test(1,c,Q,x,Para)
% %  sch = findResource('scheduler', ...
%                    'configuration', defaultParallelConfig);
% 
% 
% 
%     tic
% %       j1= batch(sch , 'ParallelCoeff', 1, {1,c,Q,x0,Para});
% % j2 = batch(sch , 'ParallelCoeff', 1, {2,c,Q,x0,Para});
% %      j3= batch(sch , 'ParallelCoeff', 1, {3,c,Q,x0,Para});
% % j4 = batch(sch , 'ParallelCoeff', 1, {4,c,Q,x0,Para});
% 
% addpath(genpath(Para.CompEconPath));
      parfor z=1:1
%      % for z=1:Para.ZSize
%         % labindex
% 
 ParallelCoeff(1,c,Q,x0,Para)
%           %('ParallelCoeff',z,c,Q,x0,Para)
% %         
       end
%      
      matlabpool close force local
        ParallelCoeff(1,c,Q,x0,Para)
%    