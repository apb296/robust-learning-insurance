% This script computes the IID shocks prvate information economy 
function MainBellman(Para)
clc
close all;
%% SET PARA

%Para.KTR.lb=[0 0 -inf -inf];
%Para.KTR.ub=[Para.y Para.y inf inf];

% BUILD GRID
[ Para,Q] = BuidGrid( Para);
disp('Msg: Completed definition of functional space')

%% INITIALIZE THE COEFF
disp('Msg: Initializing the Value function....')

tic
[ domain, c, PolicyRulesStore] = InitializeCoeff( Para, Q)    ;
toc
disp('Msg: .... Completed')
%BellmanData=load('Data/PrivateInformationAmb.mat')
%[ domain, c, PolicyRulesStore] = InitializeCoeffWithExistingSolution( Para, Q,BellmanData)   

%% INITIALIZE THE COEFF
disp('Msg: Tuning grid and value function ....')

%tic
%[ domain, c, PolicyRulesStore] = TuneValueFunction(Para,c,Q,domain,PolicyRulesStore,3) ;
%toc

disp('Msg: .... Completed')
%Para.KTR.lb=[Para.Delta*.999 Para.Delta*.999 -Inf,-Inf];
%Para.KTR.ub=[(Para.y-Para.Delta)*1.001 (Para.y-Para.Delta)*1.001  Inf Inf];
Para.KTR.lb=[0 Para.Delta Para.vSuperMin Para.vSuperMin];
Para.KTR.ub=[Para.y-Para.Delta Para.y Para.vSuperMax Para.vSuperMax];

%% OPEN MATLAB PARALLEL WORKERS
if matlabpool('size')>0
matlabpool close force local
end
matlabpool open local
%% ITERATE ON THE VALUE FUNCTION
% This block iterates on the bellman equation
% Slicing the state space for parfor loop




cdiff(1)=1;
for iter=2:Para.MaxIter
    tic    
    % Clear the records for the arrays that store the index of the point in
    % the doman (w.r.t domain) where the inner optimization failed
    IndxSolved=[];
    IndxUnSolved=[];
    ExitFlag=[];  
    % Initialize the initial guess for the policy rules that the inner
    % optimization will solve
    PolicyRulesStoreOld=PolicyRulesStore;
   parfor ctr=1:Para.vGridSize        
        
       % INITAL GUESS FOR THE INNER OPTIMIZATION
        %InitContract=PolicyRulesStore(ctr,:);
        InitContract=PolicyRulesStore(ctr,:);
        % INNER OPTIMIZATION
        strucOptimalContract=SolveInnerOptimization(domain(ctr),InitContract,Para,c,Q) ;      
        ExitFlag(ctr)=strucOptimalContract.ExitFlag;
        QNew(ctr)=strucOptimalContract.QNew;
        LambdaStore(ctr)=-strucOptimalContract.Mu.eqnonlin;
        MuStore(ctr,:)=strucOptimalContract.Mu.ineqnonlin';
        DistortedBeliefsAgent1Store(ctr,:)=strucOptimalContract.tilde_p0_agent_1 ;
    DistortedBeliefsAgent2Store(ctr,:)=strucOptimalContract.tilde_p0_agent_2 ;
    
        %UPDATE POLICY RULES
             PolicyRulesStore(ctr,:)=strucOptimalContract.Contract;   
    end
    % UPDATE NEW COEFF
    
   [ cNew ] = (FitConcaveValueFunction(Q,QNew',domain',domain(1:2:end)'))';
%cNew=funfitxy(Q,domain',QNew');
   cold=c;
   c=Para.grelax*cold+(1-Para.grelax)*cNew;
   cdiff(iter,:)=max(abs(c-cold));
  
   cStore(iter,:)=c'
   ExitFlag
    toc
   if cdiff(iter)<1e-5
       break
   end
   
   
if mod(iter,10)==0
    save(['Data/' Para.StoreFileName],'c','Q','cdiff','domain','cdiff','cStore','LambdaStore','PolicyRulesStore','Para','MuStore','ExitFlag','DistortedBeliefsAgent1Store','DistortedBeliefsAgent2Store')
end
end
mkdir('Data')
save(['Data/' Para.StoreFileName],'c','Q','cdiff','domain','cdiff','cStore','LambdaStore','PolicyRulesStore','Para','MuStore','ExitFlag','DistortedBeliefsAgent1Store','DistortedBeliefsAgent2Store')
%fsolve(@(xv)  ResidualAllConstraintsBinding(xv,Para,c,Q), [strucOptimalContract.Contract domain(1)] )