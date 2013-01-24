function strucOptimalContract=SolveSimpleContract(v,InitContract,Para,c,Q)
% SET OPTIMIZATION PARAMETER


[OptContract,fval,exitflag,~,Mu]  =ktrlink(@(x) QRU(x,Para,c,Q),InitContract,[],[],[],[],Para.KTR.lb,Para.KTR.ub,@(x) DynamicConstraintsRU(x,v,Para,c,Q),Para.KTR.opts);
strucOptimalContract.ExitFlag=exitflag;
strucOptimalContract.QNew=-fval;
strucOptimalContract.Mu=Mu;
strucOptimalContract.Contract=OptContract;
[Q,V,tilde_p0_agent_1,tilde_p0_agent_2] = ComputeValuesDistProb(OptContract(1:2),OptContract(3:4),funeval(c,Q,OptContract(3:4)')',Para.ra,Para.beta,Para.pl,Para.ph,Para.y,Para.Theta(1,1),Para.Theta(2,1));
strucOptimalContract.tilde_p0_agent_1=tilde_p0_agent_1;
strucOptimalContract.tilde_p0_agent_2=tilde_p0_agent_2;
end