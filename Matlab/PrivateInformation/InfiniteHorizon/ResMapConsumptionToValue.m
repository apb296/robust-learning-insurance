function res=ResMapConsumptionToValue(TargeConsumption,v,c,Q,Para,domain,PolicyRulesStore,z)

    InitContract=GetInitialApproxPolicy(v,domain',PolicyRulesStore);
        strucOptimalContract=SolveInnerOptimization(v,InitContract,Para,c,Q) ;      
        
        res=strucOptimalContract.Contract(z)-TargeConsumption;
end