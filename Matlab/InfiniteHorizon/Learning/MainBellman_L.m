function MainBellman_L(Para,InitData)
% This solves the infinite horizon learning case. It takes possibly two args - 1)
% The set of parameters for which we want to solve the Planners problem. 2)
% Initialization Data

switch nargin
    case 1
        flagComputeInitialCoeff='yes'; % this flag instructs the program to compute the initial coeff and policyrules.
    case 2
        flagComputeInitialCoeff='no'; % this flag instructs the program to use the user provided data to compute the initial coeff and policyrules.
    otherwise
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


% BUILD THE DOMAIN FOR v,Pi
disp('building grid begin.....')
tic
alphamin=.05; % this is used to choose the min{v}
alphamax=1-alphamin*1.5; %this is used to choose the max{v}
[VMax,VMin,VGrid,PiGrid,PiMin,PiMax,PiGridSize,VGridSize,VSuperMax,Q]...
    =BuildGrid(Para,alphamin,alphamax);
% STORE THE GRID IN THE PARA TRUC
Para.VMax=VMax;
Para.VMin=VMin;
Para.VGrid=VGrid;
Para.PiGrid=PiGrid;
Para.PiMin=PiMin;
Para.PiMax=PiMax;
Para.PiGridSize=PiGridSize;
Para.VGridSize=VGridSize;
Para.VSuperMax=VSuperMax;
GridSize=ZSize*VGridSize*PiGridSize;
Para.GridSize=GridSize;
toc
ctr=1;
for z=1:Para.ZSize
    for pi=1:Para.PiGridSize
        for v=1:Para.VGridSize
            x_state(ctr,:)=[z Para.PiGrid(pi) Para.VGrid(z,v)];
            ctr=ctr+1;
        end
    end
end

disp('building grid done.....')
% -------------------------------------------------------------------------

% --- Initialize coeffecients and populate the guess for the policyrules --
if strcmpi(flagComputeInitialCoeff,'yes')==1
    NoLearningModel1Data.c=load([Para.NoLearningPath 'Data/CoeffRU_NL_1.mat']);
    NoLearningModel2Data.c=load([Para.NoLearningPath 'Data/CoeffRU_NL_2.mat']);
    NoLearningModel1Data.Q=load([Para.NoLearningPath 'Data/QNL_1.mat']);
    NoLearningModel2Data.Q=load([Para.NoLearningPath 'Data/QNL_2.mat']);
    [c]=InitializeCUsingNoLearningSolution(Para,x_state,NoLearningModel1Data,NoLearningModel2Data,Q);
    [cEU,PolicyRules] =InitializeCoeffPolicyRulesUsingEU(Para,x_state,Q);
    % Theta(i,j)=agent(i) operator(j)
    if Para.Theta(1,1)>100
        c=cEU;
    end
else
    c=InitData.c;
    PolicyRules=InitData.PolicyRules;
end
% ------ INITIALIZING COEFF END ------ ------ ------ ------ ------ ------



% -- SET UP THE PARALLEL CONFIGURATION ----------------------------------
err=[];
try
    
    matlabpool size
    
catch err
end
if isempty(err)
    
    
    if(matlabpool('size') > 0)
        matlabpool close force local
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
% shape constraints 
CheckPiGridSize=3;
CheckPiGrid=linspace(0,1,CheckPiGridSize);
CheckVGridSize=10;
xCheckShape=[];
for z=1:Para.ZSize;
    CheckVGrid=[linspace(min(VGrid(z,:)),min(VGrid(z,:))*2,CheckVGridSize/2)...
        linspace(max(VGrid(z,:))*.9,max(VGrid(z,:)),CheckVGridSize/2)];

for piInd=1:CheckPiGridSize
    for vInd=1:CheckVGridSize
        xCheckShape=[xCheckShape; z CheckPiGrid(piInd) CheckVGrid(vInd)];
    end
end
end


% --SETUP THE ARRAYS FOR THE BELLMAN ITERATION-----------------------------
res(1:Para.GridSize,1) = struct();
QNew=zeros(1,Para.GridSize);
ExitFlag=zeros(Para.GridSize,1);
zSlice=x_state(:,1);                                                        % isolate the first component of the domain - z
PiSlice=x_state(:,2);                                                       % isolate the second component of the domain - Pi
vSlice=x_state(:,3);                                                        % isolate the third component of the domain - v

for i=2:Para.NIter
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
    
    
    UnResolvedPoints;
    UpdateValueFunction
    cdiff(i,:)=sum(abs(cOld-c));
    toc
    
    save( [Para.DataPath 'C_' num2str(i) '.mat'], 'c','Para','Q' ,'res','PolicyRules','x_state','cdiff');
    
end
save( [Para.DataPath 'FinalC.mat'],'c','Para','Q' ,'res','PolicyRules','x_state','cdiff');
end

% TODO
% if exitflag is not good - set x=xinit and dont use the points to update
% the coeff, newguesses for the policy rules

