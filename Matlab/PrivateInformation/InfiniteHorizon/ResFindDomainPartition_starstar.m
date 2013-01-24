function res=ResFindDomainPartition_starstar(x,c,Q,Para,domain,PolicyRulesStore)

vstarstar=x;
InitContract=GetInitialApproxPolicy(vstarstar,domain',PolicyRulesStore);  
strucOptimalContract=SolveInnerOptimization(vstarstar,InitContract,Para,c,Q) ;      
res=-strucOptimalContract.Mu.lower(2);
if res<1e-6
    res=-1;
end
end