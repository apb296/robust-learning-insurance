
function ExpectedReturns=ComputeExpectedReturns(z,v,pi,ValueFunctionData,PData)
% This function computes the expected returns from holding the lucas tree
% under the reference model

% Get Valuefunction Data
Para=ValueFunctionData.Para;
PolicyRules=ValueFunctionData.PolicyRules;
x_state=ValueFunctionData.x_state;
Q=ValueFunctionData.Q;
c=ValueFunctionData.c;

% Get PriceDividend Ratio data
coeffPD=PData.coeffPD;
PD=PData.PD;

% Use the policy rules to compute the state next period. I will use this to
% compute the price of the tree in the next period.
xInit=GetInitalPolicyApprox([z pi v],x_state,PolicyRules);
resQNew=getQNew(z,pi,v,c,Q,Para,xInit);
VStar=resQNew.VStar;
pistar=resQNew.pistar;

% This inline function computes the ex -divident price of the tree
      % Price =PD x Y
      PriceOfTree=@(z,v,pi) funeval(coeffPD(z,:)',PD(z),[pi v])*Para.Y(z);
      
% Now we compute the holding period returns from the tree i.e (P*+Y*)/(P)
      RealizedReturns=ones(1,Para.ZSize);
      
for zstar=1:Para.ZSize
    RealizedReturns(zstar)=(PriceOfTree(zstar,VStar(zstar),pistar(zstar))+Para.Y(zstar))/PriceOfTree(z,v,pi);
end

% Finally we compute the expected returns under the reference measure
EffProb=pi*Para.P(z,:,1)+(1-pi)*Para.P(z,:,2);   
ExpectedReturns=sum(EffProb.*RealizedReturns);   
end