% This program initializes the value function iteration using the solutions
% of the no learning case. It also stores the guess for the policies for
% future 


% ----- CHECK THE EXISTING COEFFECIENTS -----------------------------------
% The file initialC.mat stores the last initialization. If this exists I
% do not recompute using the no-learning average.
flagComputeInitialC=1;
    InitialCPath=[Para.DataPath 'InitialC.mat'];
if exist(InitialCPath)==2
InitialC=load([Para.DataPath 'InitialC.mat']);
flag = CheckPara(Para,InitialC.Para);
if (flag==1 || flagOverrideInitialCheck==1)
    disp('Using existing initial guess')
    flagComputeInitialC=0;
    c=InitialC.c;
     x_state=InitialC.x_state;
    PolicyRules=InitialC.PolicyRules;
end
end
%% COMPUTE THE INITIAL COEFFS

if flagComputeInitialC==1

    
    %% NO LEARNING SOLUTION
    % ??? - ADD A CHECK FOR THETA. IF THETA HAVE CHANGED RECOMPUTE THE NO
    % LEARNING CASE OR USE EXPECTED UTILITY
    
    
    
    % REcover the value functions for the no learning case for both the
    % models
 CoeffRU_NL_1=load([Para.NoLearningPath 'Data/CoeffRU_NL_1.mat']);
 CoeffRU_NL_2=load([Para.NoLearningPath 'Data/CoeffRU_NL_2.mat']);
 QNL_1=load([ Para.NoLearningPath 'Data/QNL_1.mat']);
 QNL_2=load([ Para.NoLearningPath 'Data/QNL_2.mat']);

 % for each point in the grid
 n=1;
for z=1:Para.ZSize
    tic
    ctr=1;
    if (z==1 || z==3)
    for pi=1:PiGridSize
        x0_1=[];
        x0_2=[];
        for v=1:VGridSize
 % Get the No learning solution for model 1
cd(Para.NoLearningPath)
cNL_1(1,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(2,:)=CoeffRU_NL_1.coeff(1,:);
cNL_1(3,:)=CoeffRU_NL_1.coeff(2,:);
cNL_1(4,:)=CoeffRU_NL_1.coeff(2,:);
Para.m=1;
resQNew_1=getQNew(z,VGrid(z,v),cNL_1,QNL_1.Q,Para,x0_1);
Cons_1=resQNew_1.Cons;
VStar_1=resQNew_1.VStar;
QNew_1=resQNew_1.QNew;
x0_1=[Cons_1 VStar_1(1) VStar_1(3)];
ExitFlag(z,pi,v)=resQNew_1.ExitFlag;

% Get the No learning solution for model 2
cNL_2(1,:)=CoeffRU_NL_2.coeff(1,:);
cNL_2(2,:)=CoeffRU_NL_2.coeff(1,:);
cNL_2(3,:)=CoeffRU_NL_2.coeff(2,:);
cNL_2(4,:)=CoeffRU_NL_2.coeff(2,:);
Para.m=2;
resQNew_2=getQNew(z,VGrid(z,v),cNL_2,QNL_2.Q,Para,x0_2);
Cons_2=resQNew_2.Cons;
VStar_2=resQNew_2.VStar;
QNew_2=resQNew_2.QNew;
x0_2=[Cons_2 VStar_2(1) VStar_2(3)];
ExitFlag(z,ctr)=resQNew_2.ExitFlag*ExitFlag(z,pi,v);

%Average the solutions for the learning case
ConsNL=PiGrid(pi)*Cons_1+(1-PiGrid(pi))*Cons_2;
VStarNL=PiGrid(pi)*VStar_1+(1-PiGrid(pi))*VStar_2;
QNewNL=PiGrid(pi)*QNew_1+(1-PiGrid(pi))*QNew_2;
                      
          
cd(Para.LearningPath)
% check for complex values
if (isreal(QNewNL))
          x(ctr,:)=[PiGrid(pi) VGrid(z,v)];
  
    QL0(ctr)=QNewNL;
            ctr=ctr+1;
            
end 
x_state(n,:)=[z PiGrid(pi) VGrid(z,v)];
PolicyRules(n,:)=[ConsNL VStarNL];
n=n+1;

        end
        
    end
    c(z,:)=funfitxy(Q(z),x(logical(ExitFlag(z,:)==1),:),QL0(logical(ExitFlag(z,:)==1))' );
    else
      c(z,:)=c(z-1,:);
x_state=vertcat(x_state,x_state(end-PiGridSize*VGridSize+1:end,:));
x_state(end-PiGridSize*VGridSize+1:end,1)=x_state(end-PiGridSize*VGridSize+1:end,1)+1;

    PolicyRules=vertcat(PolicyRules,PolicyRules(end-PiGridSize*VGridSize+1:end,:));
    n=n+PiGridSize*VGridSize;
    end
    
    toc
    disp('Initialized z = ');
    disp(z);
end

save( [Para.DataPath 'InitialC.mat'], 'c','Para','Q','PolicyRules','x_state')
end


zSlice=x_state(:,1);
PiSlice=x_state(:,2);
vSlice=x_state(:,3);
