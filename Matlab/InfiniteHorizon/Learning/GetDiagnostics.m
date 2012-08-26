function [QNew Cons LambdaStar LambdaStarL VStar DelVStar DistPi_agent1 DistPi_agent2 ExitFlag MuCons SigmaCons EntropyMargAgent1 EntropyMargAgent2 PK MPR ConsStar ConsStarRatio MuDelVStar DistMargAgent1 DistMargAgent2]=GetDiagnostics(c,Q,PolicyRules,Para)
addpath(genpath(Para.CompEconPath));
Y=Para.Y;
PiGridSize=Para.PiGridSize;
VGridSize=Para.VGridSize;
PiGrid=Para.PiGrid;
VGrid=Para.VGrid;
ra=Para.RA;
n=1;
 for z=1:Para.ZSize
 disp('...Computing Results for z=')
 disp(z)
for pi=1:PiGridSize
    
    for v=1:VGridSize
        xInit=PolicyRules(n,:);
      resQNew=getQNew(z,PiGrid(pi),VGrid(z,v),c,Q,Para,xInit);
        %resQNew=res(n);
        n=n+1;
      
        QNew(z,pi,v)=resQNew.Q;
        Cons(z,pi,v)=resQNew.Cons;
        LambdaStar(z,pi,v,:)=resQNew.LambdaStar;
        LambdaStarL(z,pi,v,:)=resQNew.LambdaStar/(resQNew.Lambda);
        VStar(z,pi,v,:)=resQNew.VStar;
        DelVStar(z,pi,v,:)=resQNew.VStar-VGrid(z,v);
        DistPi_agent1(z,pi,v)=resQNew.DistPi_agent1;
        DistPi_agent2(z,pi,v)=resQNew.DistPi_agent2;
        ExitFlag(z,pi,v)=resQNew.ExitFlag;  
        MuCons(z,pi,v)=resQNew.MuCons;
        SigmaCons(z,pi,v)=resQNew.SigmaCons;
        Entropy_Z_Model1(z,pi,v)=resQNew.Entropy_Z_Model1;
        Entropy_Z_Model2(z,pi,v)=resQNew.Entropy_Z_Model2;
        Entropy_M(z,pi,v)=resQNew.Entropy_M;
        PK(z,pi,v,:)=resQNew.PricingKernel;
        MPR(z,pi,v,:)=resQNew.MPR;
        ConsStar(z,pi,v,:)=resQNew.ConsStar;
        ConsStarRatio(z,pi,v,:)=(resQNew.ConsStar./Y)./(Cons(z,pi,v)/(Y(z)));
        %ConsStarRatio(z,pi,v,:)=LambdaStar(z,pi,v,:).^(-1/ra);
        
        MuDelVStar(z,pi,v)=resQNew.MuDelVStar;
        DistMargAgent1(z,pi,v,:)=resQNew.DistMarg_agent_1;
        DistMargAgent2(z,pi,v,:)=resQNew.DistMarg_agent_2;
        EntropyMargAgent1(z,pi,v)=resQNew.Entropy_Marg_Agent1;
        EntropyMargAgent2(z,pi,v)=resQNew.Entropy_Marg_Agent2;
        
    end
end
 end
 