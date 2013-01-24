function [ domain, c, PolicyRulesStore] = InitializeCoeffWithExistingSolution( Para, Q,BellmanData)   
beta=Para.beta;
pl=Para.pl;
ph=Para.ph;
theta=Para.Theta(1,1);
ra=Para.ra;
Delta=Para.Delta;
y=Para.y;
domain=Para.vGrid;
c=funfitxy(Q,domain',funeval(BellmanData.c,BellmanData.Q,domain'));
for vind=1:Para.vGridSize
   PolicyRulesStore(vind,:)=GetInitialApproxPolicy(domain(vind), BellmanData.domain',BellmanData.PolicyRulesStore);
end
end
