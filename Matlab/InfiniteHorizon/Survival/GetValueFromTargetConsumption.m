function [ res ] = GetValueFromTargetConsumption(v,y,TargetCons,InitData)
 resQNew=getQNew(y,v,InitData.c,InitData.Q,InitData.Para,GetInitalPolicyApprox([y v],InitData.x_state,InitData.PolicyRules));
 res(1)=resQNew.Cons/InitData.Para.Y(y)-TargetCons;             
end

