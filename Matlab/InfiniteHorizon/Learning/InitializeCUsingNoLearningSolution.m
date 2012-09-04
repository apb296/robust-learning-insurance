function[c]=InitializeCUsingNoLearningSolution(Para,x_state,NoLearningModel1Data,NoLearningModel2Data,Q)

% This program initializes the value function iteration using the solutions
% of the no learning case.

% REcover the value functions for the no learning case for both the
% models
CoeffNLModel1(1,:)=NoLearningModel1Data.c.coeff(1,:);                       % Get the NoLearning Model 1 coeffs z=1
CoeffNLModel1(2,:)=NoLearningModel1Data.c.coeff(1,:);                       % Get the NoLearning Model 1 coeffs z=2
CoeffNLModel1(3,:)=NoLearningModel1Data.c.coeff(2,:);                       % Get the NoLearning Model 1 coeffs z=3
CoeffNLModel1(4,:)=NoLearningModel1Data.c.coeff(2,:);                       % Get the NoLearning Model 1 coeffs z=4

CoeffNLModel2(1,:)=NoLearningModel2Data.c.coeff(1,:);                       % Get the NoLearning Model 1 coeffs z=1
CoeffNLModel2(2,:)=NoLearningModel2Data.c.coeff(1,:);                       % Get the NoLearning Model 1 coeffs z=2
CoeffNLModel2(3,:)=NoLearningModel2Data.c.coeff(2,:);                       % Get the NoLearning Model 1 coeffs z=3
CoeffNLModel2(4,:)=NoLearningModel2Data.c.coeff(2,:);                       % Get the NoLearning Model 1 coeffs z=4


QNLModel1=NoLearningModel1Data.Q.Q;                                          % Get the NoLearning Model 1 value function
QNLModel2=NoLearningModel1Data.Q.Q;                                          % Get the NoLearning Model 2 value function

% for each point in the grid

for z=1:Para.ZSize
    tic
    
    if (z==1 || z==3)
        
        zIndx= find(x_state(:,1)==z);
        QNewModel1=funeval(CoeffNLModel1(z,:)',QNLModel1(z),x_state(zIndx,end));    % Model 1 NoLearning Value
        QNewModel2=funeval(CoeffNLModel2(z,:)',QNLModel2(z),x_state(zIndx,end));    % Model 2 NoLearning Value
        AverageQNewNL=x_state(zIndx,2).*QNewModel1+(1-x_state(zIndx,2)).*QNewModel2;   % Average of the two with Pi
        c(z,:)=funfitxy(Q(z),x_state(zIndx,2:end),AverageQNewNL);
    else
        c(z,:)=c(z-1,:);
    end
    
    
    
end


