% Edited on Aug 22 2012
% This solves the infinite horizon no learning case using either splines or
% cheb polynomials. The program takes two inputs  - The Para structure and
% the indicator for the type of model. model=1 is IID model and model=2 is
% the Non IID model

function Main_NL(model,Para)
% set the default model to 1
if isempty(model)
    model=1;
end

clc
close all

% Retrive variables from the struc
[DataPath,NoLearningPath,LearningPath,P_M,delta,Y,M,Theta,P,RA,MSize,ZSize,ctol,grelax,NIter,StateName,N,ApproxMethod,OrderOfApproximationPi,OrderOfApproximationV]=GetVariables(Para);

%% Set the Parallel Config
err=[];
try
    matlabpool
catch err
end
if isempty(err)
    
    
    if(matlabpool('size') > 0)
        matlabpool close
    end
    
    matlabpool open local;
    
end

% Set the reference model to be as desired
Para.m=model;
% This defines the sparsity of the grid. Currently it uses thrice as many
% points as the order of approximation. This can be increased but will make
% the program slower
VGridSize=OrderOfApproximationV*3;
Para.VGridSize=VGridSize;
% Grid for State-Space. The value function has one contiuous state variable
% v or the initial promised value and one dicrete variable z capturing the
% exogenous shocks. The program BuildGrid sets up the grid and defines the
% functional space for the value function iteration.

[Q,VGrid,VSuperMax,GridSize]=BuildGrid(Para);
Para.GridSize=GridSize;
% To initialize the coeffecient we use the EU solution as the starting
% point
[x_state,PolicyRules,cEU0]=InitializeC(Para,VGrid,VGridSize,Q);
zSlice=x_state(:,1);
vSlice=x_state(:,2);
load('Data/coeffEU.mat');
c0=cEU0;
% -- Solve the Value function by Iterating on the Bellman equation --------
disp('...Solving Model - ')
disp(model)
c=c0;


for i=1:NIter
    tic
     ExitFlag=zeros(GridSize,1);
     parfor GridInd=1:GridSize
      z=zSlice(GridInd);
        v=vSlice(GridInd);
       xInit=PolicyRules(GridInd,:);
       
       
        
        if (z==1 || z==3)                                                   % Solve for z:y(z)=y
            
    
                
                resQNew=getQNew(z,v,c,Q,Para,xInit);                  % Solve the inner optimization for z, V(z,v)
                QNew(GridInd)=resQNew.QNew;                                     % Recover the new guess for Q(z,v)
                Cons(GridInd)=resQNew.Cons;                                     % Recover the consumptiop policy C[z,v]
                VStar(GridInd,:)=resQNew.VStar;                                 % Recover the values next period  Vstar[zstar|z,v]
                PolicyRules(GridInd,:)=[resQNew.Cons resQNew.VStar(1) resQNew.VStar(3)];
                ExitFlag(GridInd)=resQNew.ExitFlag;                               % Exit status of the innder optimization
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
    disp('iter=')
    disp(i)
    save( ['Data/C_' num2str(i) '.mat'], 'c','Para','Q','VGrid','cdiff');
    toc
end
coeff=c([1 3],:);
% ----- STORING THE RESULTS-------------------------------------------------
CoeffFileName=['CoeffRU_NL_' int2str(m) '.mat'];                       % Coeffecients
FSpaceFileName=['QNL_' int2str(m) '.mat'];                             % Value functions
ParaFileName=['Para_NL_' int2str(m) '.mat'];                           % Para


save(['Data/' FSpaceFileName],'Q');
save(['Data/' CoeffFileName],'coeff');
save(['Data/' ParaFileName],'Para');

end




%matlabpool close force localConsShare
%load(CoeffFileName);
%matlabpool close
%save('InitGuessCoeff.mat','c')
% Use this code to do a fixed point on the coeff
%options = optimset('Display','iter','TolFun',ctol,'FunValCheck','off','TolX',ctol);
%c0=c([1 3],:);
%save(CoeffFileName,'c0');
%coeff=fsolve(@(coeff) resQcoeff2(coeff,Q,Para) ,c0,options);


%c(1,:)=coeff(1,:);
%c(2,:)=coeff(1,:);
%c(3,:)=coeff(2,:);
%c(4,:)=coeff(2,:);

% for z=1:ZSize
%     tic
%     for v=1:VGridSize
%         resQNew=getQNew(z,VGrid(z,v),c,Q,Para);
%         QNew(z,v)=resQNew.QNew;
%         Cons(z,v)=resQNew.Cons;
%         ConsShare(z,v)=resQNew.ConsShare;
%         LambdaStarRatio(z,v)=resQNew.LambdaStar(2)/resQNew.LambdaStar(3);
%         VStar(z,v,:)=resQNew.VStar;
%         DelVStar(z,v,:)=resQNew.VStar-VGrid(z,v);
%         for zstar=1:ZSize
%         resQNew=getQNew(zstar,VStar(z,v,zstar),c,Q,Para);
%         ConsShareStar(z,v,zstar)=resQNew.ConsShare;
%         end

% end

%ConsFileName=['Cons_NL_' int2str(m) '.mat'];
%VStarFileName=['VStar_NL_' int2str(m) '.mat'];
%save(ConsFileName,'Cons','ConsShare')
%save(VStarFileName,'VStar')
