function res=ResFindDomainPartition_star(x,c,Q,Para,domain,PolicyRulesStore)
vstar=x(1);
InitContract=GetInitialApproxPolicy(vstar,domain',PolicyRulesStore);  
strucOptimalContract=SolveInnerOptimization(vstar,InitContract,Para,c,Q) ;      

res=1e-5-strucOptimalContract.Mu.upper(1);

%vstarstar=x(2);
%InitContract=GetInitialApproxPolicy(vstarstar,domain',PolicyRulesStore);  
%strucOptimalContract=SolveInnerOptimization(vstarstar,InitContract,Para,c,Q) ;      
%res(2)=strucOptimalContract.Mu.lower(2);
end