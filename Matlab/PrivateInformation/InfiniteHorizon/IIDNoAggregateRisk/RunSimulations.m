function     SimData =RunSimulations(v0,rHist,NumSim,domain,PolicyRulesStore,Para)

vHist(1)=v0;
zHist(1)=1;
InitContract=GetInitialApproxPolicy(v0,domain', PolicyRulesStore);

for t=1:NumSim
    % Find the optimal conract for t
     strucOptimalContract=SolveInnerOptimization(vHist(t),InitContract,Para,c,Q) ;     
    cHistMenu(t,:)=strucOptimalContract.Contract(1:2);
    cHist(t,:)=cHistMenu(t,zHist(t));
    LambdaHist(t)=-strucOptimalContract.Mu.eqnonlin;
    MuHist(t,:)=strucOptimalContract.Mu.ineqnonlin';
    InitContract=strucOptimalContract.Contract;
    strucOptimalContract.ExitFlag;
    DistortedBeliefsAgent1(t,:)=strucOptimalContract.tilde_p0_agent_1 ;
    DistortedBeliefsAgent2(t,:)=strucOptimalContract.tilde_p0_agent_2 ;
    
    % Draw z shock
    if rHist(t+1) < Para.pl(1)
    zHist(t+1)=1;
    else
        zHist(t+1)=2;
    end        
   % update the continuation values
  vHist(t+1)=strucOptimalContract.Contract(2+zHist(t+1)) ;        
end
SimData.zHist=zHist;
SimData.vHist=vHist;
SimData.cHistMenu=cHistMenu;
SimData.LambdaHist=LambdaHist;
SimData.MuHist=MuHist;
SimData.DistortedBeliefsAgent1=DistortedBeliefsAgent1;
SimData.DistortedBeliefsAgent2=DistortedBeliefsAgent2;
SimData.cHist=cHist;