function [ res ] = GetValueFromTargetConsumption(v,z,pi,TargetCons,InitData)
xInit=GetInitalPolicyApprox([z pi v],InitData.x_state,InitData.PolicyRules);
resQNew=getQNew(z,pi,v,InitData.c,InitData.Q,InitData.Para,xInit);
if ~(resQNew.ExitFlag==1)
    disp('Fixing with alternative starting point')
    xInit=xInit*(1+.1*rand);
resQNew=getQNew(z,pi,v,InitData.c,InitData.Q,InitData.Para,xInit);
disp('Result')
resQNew.ExitFlag
end

res(1)=resQNew.Cons/InitData.Para.Y(z)-TargetCons;             
end

