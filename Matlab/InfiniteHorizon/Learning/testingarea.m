
    load Data/theta_1_infty/Persistent/FinalC.mat
    fplot(@(v) funeval(c(3,:)', Q(3) ,[.111 v]), [2.30 10])
    
     z=3.0000    
     v=2.3212   
     pi=0
     xtest=[z pi v];
     xInit=GetInitalPolicyApprox(xtest,x_state,PolicyRules)
                 resQNew=getQNew(z,pi,v,c,Q,Para,xInit)
