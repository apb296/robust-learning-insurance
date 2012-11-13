function [ res] = ResVBar(v,z,pi,SolData)
% This function computes the residual for the following
% LambdaStart/Lambda-1
x_state=SolData.x_state;
PolicyRules=SolData.PolicyRules;
c=SolData.c;
Q=SolData.Q;
Para=SolData.Para;
xInit=GetInitalPolicyApprox([z pi v],x_state,PolicyRules);
%resQNew=getQNew(z,pi,v,c,Q,Para,xInit);
%res=resQNew.Lambda-1;
res=funeval(c(z,:)',Q(z),[ pi v])-v;

end

