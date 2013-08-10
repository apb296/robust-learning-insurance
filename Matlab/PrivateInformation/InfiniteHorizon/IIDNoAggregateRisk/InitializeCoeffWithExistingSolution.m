function [ domain, c, PolicyRulesStore] = InitializeCoeffWithExistingSolution( Para, Q,BellmanData)   
domain=Para.vGrid;
c=funfitxy(Q,domain',funeval(BellmanData.c,BellmanData.Q,domain'));
for vind=1:Para.vGridSize
   PolicyRulesStore(vind,:)=GetInitialApproxPolicy(domain(vind), BellmanData.domain',BellmanData.PolicyRulesStore);
end
end
