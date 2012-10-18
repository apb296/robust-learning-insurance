% This small program computes the initializes the value function with user
% supplied coeff
% coeffecients
function [x_state,PolicyRules,c0]=InitializeCUsingInterpolation(Para,Q,InitData)
YSize=length(Para.Y);
VGrid=Para.VGrid;
VGridSize=Para.VGridSize;
GridSize=Para.GridSize;
Y=Para.Y;
ctr=1;
x_state=ones(GridSize,2);
PolicyRules=ones(GridSize,3);
cInit=InitData.c;
QInit=InitData.Q;
x_stateInit=InitData.x_state;
PolicyRulesInit=InitData.PolicyRules;

for y=1:YSize
for vind=1:VGridSize
     x_state(ctr,:)=[y,VGrid(y,vind)];
        
        QNew(y,vind)=funeval(cInit(y,:)' ,QInit(y), VGrid(y,vind));
 PolicyRules(ctr,:)=GetInitalPolicyApprox(x_state(ctr,:),x_stateInit,PolicyRulesInit);
 ctr=ctr+1;
 
end

% Compute the initial coeffecient for EU case
c0(y,:)=funfitxy(Q(y),VGrid(y,:)',QNew(y,:)');
end
% Check that coeffecients are real
if isreal(c0)
    disp('Initial Coeff are real')
    disp(c0)
save('Data/coeffInit.mat','cInit');
else 
       disp('Initial Coeff are complex')
end


