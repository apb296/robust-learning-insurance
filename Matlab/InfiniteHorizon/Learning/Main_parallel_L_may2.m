% This solves the infinite horizon learning case
if ~(exist('Para')==1)
clc
clear all
close all
disp('Running with default settings');
 SetParaStruc_p_learning;
end

% ------GET THE PARAMETERS FROM PARASTRUC----------------------------------
%This makes sure that the orphan para are defined if SetPAraStruc_p_learning is not executed
[DataPath,NoLearningPath,LearningPath,P_M,delta,Y,M,Theta,P,RA,MSize,ZSize...
    ,ctol,grelax,NIter,StateName,N,ApproxMethod,OrderOfApproximationPi,...
    OrderOfApproximationV]=GetVariables(Para);


%--------------------------------------------------------------------------
%%RUN THIS PART TO SOLVE FOR THE NO LEARNING CASES
%    warning off all
%      cd(Para.NoLearningPath)
%      m_true=1;
%      Main_NL(m_true,Para)
%       m_true=2;
%       Main_NL(m_true,Para)   
%     cd(Para.LearningPath)

disp('set para struc done.....')
%--------------------------------------------------------------------------

% ------ INITIALIZING COEFF BEGIN------ ------ ------ ------ ------ ------

flagOverrideInitialCheck=0;
% Grid for State-Space
disp('building grid begin.....')
tic
BuildGrid;
toc
disp('building grid done.....')
disp('Initializing Coeffecients begin.....')
flagOverrideInitialCheck=0;
if theta11 <10
%InitializeC_EU;
InitializeC
else
disp('Using EU solution')
    InitializeC_EU;
%InitializeC;
end
disp('Initializing Coeffecients done.....')

% ------ INITIALIZING COEFF END ------ ------ ------ ------ ------ ------



% -- SET UP THE PARALLEL CONFIGURATION ----------------------------------
err=[];
try

    matlabpool size

catch err
end
if isempty(err)
    
    
    if(matlabpool('size') > 0)
        matlabpool close
    end
    
    matlabpool open local;
    
end


% ------------------------------------------------------------------------


% -- DISPLAY THE CASE THAT IS BEING SOLVED --------------------------------
 disp('Theta')
 disp(Para.Theta)
 disp('PM')
 disp(Para.P_M)
% ------------------------------------------------------------------------

% --SETUP THE ARRAYS FOR THE BELLMAN ITERATION-----------------------------
res(1:Para.GridSize,1) = struct();
QNew=zeros(1,Para.GridSize);
ExitFlag=zeros(Para.GridSize,1);
 
for i=2:NIter
    disp('Starting Iteration No')
    disp(i)
   
    tic

  parfor GridInd=1:Para.GridSize
  
        z=zSlice(GridInd);
        v=vSlice(GridInd);
        pi=PiSlice(GridInd);
xInit=PolicyRules(GridInd,:);
% since the value function depends only on y
 if (z==1 || z==3)
 resQNew=getQNew(z,pi,v,c,Q,Para,xInit);
QNew(GridInd)=resQNew.Q;
PolicyRules(GridInd,:)=[resQNew.Cons resQNew.VStar];
ExitFlag(GridInd,:)=resQNew.ExitFlag;

 end

   end



 
          QNew(GridSize/4+1:2*GridSize/4)=QNew(1:GridSize/4);
          QNew(3*GridSize/4+1:GridSize)=QNew(GridSize/2+1:3*GridSize/4);
          
PolicyRules(GridSize/4+1:2*GridSize/4,:)=PolicyRules(1:GridSize/4,:);
PolicyRules(3*GridSize/4+1:GridSize,:)=PolicyRules(GridSize/2+1:3*GridSize/4,:);
ExitFlag(GridSize/4+1:2*GridSize/4)=ExitFlag(1:GridSize/4);
ExitFlag(3*GridSize/4+1:GridSize)=ExitFlag(GridSize/2+1:3*GridSize/4);


 
UpdateValueFunction
     cdiff(i,:)=sum(abs(cOld-c));
     toc
     
save( [Para.DataPath 'C_' num2str(i) '.mat'], 'c','Para','Q' ,'res','PolicyRules','x_state','cdiff');   

end
save( [Para.DataPath 'FinalC.mat'],'c','Para','Q' ,'res','PolicyRules','x_state','cdiff');   
