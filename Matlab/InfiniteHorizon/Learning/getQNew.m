 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % This program computes solves the FOC for a given state. It returns a
 % structure that contains useful objects computed as a part of the
 % solution
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resQNew=getQNew(zz,ppi,vv,cc,QQ,PPara,xInit)
global Q c Para z pi v
%-------Get the Para from the struct --------------------------------------
Para=PPara;
z=zz;
pi=ppi;
v=vv;
c=cc;
Q=QQ;
ZSize=Para.ZSize;
delta=Para.delta;
Y=Para.Y;
ctol=Para.ctol;
ra=Para.RA;
VSuperMax=Para.VSuperMax;

  
% ------- Solve the FOC with NAG toolbox ----------------------------------

[x, fval,~,ifail]=c05qb('resQNAG',xInit);

       switch ifail
             case {0}
              exitflag=1;
            case {2, 3, 4}
            exitflag=-2;
            x=xInit;
        end

% ------------------------------------------------------------------------
 
 
%%% ?????? %%%%%
% WHAT IF VSTAR IS GREATED THAN MAX(VGRID(ZSTAR)) OR VSUPERMAX(ZSTAR).
% WRITE A ROUTINE TO COMPUTE THE FOC WITH BOUNDS ON VSTAR.
%if max(x(2:5)-VSuperMax)>0
%    exitflag=-1;
%end

% -------Compute the rest of the objects using the solution ---------------
% The code below stores the solution in the structure resQNew
% - Storing the guess ----------------------------------------------------
cons=x(1);
VStar(1)=x(2);
VStar(2)=x(3);
VStar(3)=x(4);
VStar(4)=x(5);
% -- Retriving the Paramters --------------------------------------------
Y=Para.Y;
delta=Para.delta;
ZSize=Para.ZSize;
P=Para.P;
P_M=Para.P_M;
theta1=Para.Theta(1,1);
theta2=Para.Theta(1,2);
PiMin=Para.PiMin;
PiMax=Para.PiMax;
MSize=Para.MSize;
VSuperMax=Para.VSuperMax;
ra=Para.RA;

    
    
% FOC (1) -----------------------------------------------------------------
    % this is the first order condition with respect to c
    lambda=(der_u(cons,ra)/der_u(Y(z)-cons,ra));
    
% ------------------------------------------------------------------------
    

% ---- APPLYING BAYES RULE ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
    pi_m=[pi 1-pi];
    for zstar=1:ZSize
        % Updating the filter using bayes law (checked the code with
        % HMMFilter.m)
        % pistar(zstar,mstar|z,pi) propto sum_m(pi(m)P_M(m,mstar)P(z,zstar,m))
        for m_star_indx=1:MSize
            Num=0;
            for m_indx=1:MSize
                Num=Num+P(z,zstar,m_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx);
            end
            pi_m(m_star_indx)= Num;
        end
        D=sum(pi_m(:));
        % Normalizing pistar
        pi_m_star= pi_m(:)/D;
        pistar(zstar)=pi_m_star(1);
        
        % This adjustment keeps the pi within the bounds of state space
        if pistar(zstar)<PiMin
            pistar(zstar)=PiMin;
        end
        if pistar(zstar)>PiMax
            pistar(zstar)=PiMax;
        end
 % ------------------------------------------------------------------------
 
        % Using envelope theorem to compute lambda(zstar)
        lambdastar(zstar) = -funeval(c(zstar,:)',Q(zstar),[ pistar(zstar) VStar(zstar)],[0 1]);
        
        % Computing QStar using the guess for the value function and sate
        % tomorrow
        
        QStar(zstar)=funeval(c(zstar,:)',Q(zstar),[ pistar(zstar) VStar(zstar)]);
        
        % This computes the model specific distorted transition given the values
        % for both the agent. the first step computes the un normalized probability
        for m=1:MSize
            p_tilde_agent1(zstar,m)=P(z,zstar,m)*exp(-QStar(zstar)/theta1);
            p_tilde_agent2(zstar,m)=P(z,zstar,m)*exp(-VStar(zstar)/theta1);
         end
        
    end
    % normalize the distorted probabilities for adding up to 1 for each
    % model
    for m=1:MSize
        D_agent1(m)= sum(p_tilde_agent1(:,m));
        D_agent2(m)= sum(p_tilde_agent2(:,m));
        for zstar=1:ZSize
            
            p_tilde_agent1(zstar,m)=p_tilde_agent1(zstar,m)/D_agent1(m);
            p_tilde_agent2(zstar,m)=p_tilde_agent2(zstar,m)/D_agent2(m);
        end
    end
    
    % Now compute the T1 operator for both the agents. Note that this iperator
    % takes the distorted expectation for the value tomorrow given a particular
    % model. Note that it does not include the discounting
    
    for m=1:MSize
        T1_agent1(m)=-theta1*log(sum(P(z,:,m).*exp(-QStar/theta1)))   ;
        T1_agent2(m)=-theta1*log(sum(P(z,:,m).*exp(-VStar/theta1)))   ;
    end
    % Now compute the distorted prior (pi tilde) for model 1 using the
    % value functions and consumption today for both the agents
    
    
    pi_tilde_agent1_model1 = pi*exp(-(u(cons,ra)+delta*T1_agent1(1))/theta2);
    pi_tilde_agent1_model2 =(1-pi)*exp(-(u(cons,ra)+delta*T1_agent1(2))/theta2);
    pi_tilde_agent1=pi_tilde_agent1_model1/(pi_tilde_agent1_model1+pi_tilde_agent1_model2);
    
    
    pi_tilde_agent2_model1 = pi*exp(-(u(Y(z)-cons,ra)+delta*T1_agent2(1))/theta2);
    pi_tilde_agent2_model2 =(1-pi)*exp(-(u(Y(z)-cons,ra)+delta*T1_agent2(2))/theta2);
    pi_tilde_agent2=pi_tilde_agent2_model1/(pi_tilde_agent2_model1+pi_tilde_agent2_model2);
    
    % Now compute the distorted marginal for zstar across models using
    % the distorted prior and distorted transitions. Note that this is
    % agent specific.
    
    for zstar=1:ZSize
        dist_marg_agent1(zstar)= pi_tilde_agent1*p_tilde_agent1(zstar,1)+(1-pi_tilde_agent1)*p_tilde_agent1(zstar,2);
        dist_marg_agent2(zstar)=pi_tilde_agent2*p_tilde_agent2(zstar,1)+(1-pi_tilde_agent2)*p_tilde_agent2(zstar,2);
        
    end
    
    EffProb=pi*P(z,:,1)+(1-pi)*P(z,:,2);   
ConsStar=Y-Y.*((1+lambdastar.^(-1/ra))'.^-1);
MuCons= EffProb*ConsStar;
SigmaCons=(EffProb*(ConsStar-MuCons).^2)^.5;


DelVStar=VStar-v;
MuDelVStar=EffProb*(DelVStar)';




mlogm_Z_Model1=(p_tilde_agent1(:,1)'./P(z,:,1)).*log(p_tilde_agent1(:,1)'./P(z,:,1));
Entropy_Z_Model1=P(z,:,1)*mlogm_Z_Model1';
mlogm_Z_Model2=(p_tilde_agent1(:,2)'./P(z,:,2)).*log(p_tilde_agent1(:,2)'./P(z,:,2));
Entropy_Z_Model2=P(z,:,2)*mlogm_Z_Model2';

switch pi
    case 0
        mlogm_M=[ 0 0];
    case 1
        mlogm_M=[ 0 0];
    otherwise
mlogm_M=[(pi_tilde_agent1/(pi))*log((pi_tilde_agent1/(pi))) ((1-pi_tilde_agent1)/(1-pi))*log(((1-pi_tilde_agent1)/(1-pi)))];
end
%Entropy of marginals
Emlogm_distmarg_agent1=sum((dist_marg_agent1./EffProb).*log((dist_marg_agent1./EffProb)).*EffProb);
Emlogm_distmarg_agent2=sum((dist_marg_agent2./EffProb).*log((dist_marg_agent2./EffProb)).*EffProb);
GrowthRateY=Y./Y(z);
PK=delta*dist_marg_agent1.*(ConsStar/cons)'.^(-ra)./EffProb;
Zeta=(dist_marg_agent1.*(ConsStar/cons)'.^(-ra).*(Y(z)./Y)'.^(-ra))./EffProb;
MuPK= EffProb*PK';
SigmaPK=(EffProb*(PK-MuPK)'.^2)^.5;
MPR=SigmaPK/MuPK;
Entropy_M=[pi 1-pi]*mlogm_M';


%-------Now Store the results in resQNew structure  ----------------------

resQNew.Q=-theta2*log(exp(-(u(cons,ra)+delta*T1_agent1)/theta2)*([pi; 1-pi]));
resQNew.DistP_agent1=p_tilde_agent1;
resQNew.DistP_agent2=p_tilde_agent2;
resQNew.pistar=pistar;
resQNew.DistPi_agent1=pi_tilde_agent1;
resQNew.DistPi_agent2=pi_tilde_agent2;
resQNew.DistMarg_agent_1=dist_marg_agent1;
resQNew.DistMarg_agent_2=dist_marg_agent2;
resQNew.LambdaStar=lambdastar;
resQNew.Cons=cons;
resQNew.VStar=VStar;
resQNew.fval=fval;
resQNew.ExitFlag=exitflag;
resQNew.Lambda=lambda;
resQNew.LambdaStarL=lambdastar/(lambda);
resQNew.DelVStar=DelVStar;
resQNew.MuDelVStar=MuDelVStar;
resQNew.ConsStar=ConsStar;
resQNew.ConsStarRatio=(resQNew.ConsStar./Y)./(cons/(Y(z)));
resQNew.MuCons=MuCons;
resQNew.SigmaCons=SigmaCons;
resQNew.Entropy_Z_Model1=Entropy_Z_Model1;
resQNew.Entropy_Z_Model2=Entropy_Z_Model2;
resQNew.Entropy_M=Entropy_M;
resQNew.Zeta=Zeta;
resQNew.MRS=Zeta.*(GrowthRateY)'.^(-ra);
resQNew.PricingKernel=PK;
resQNew.MPR=MPR;
resQNew.MuPK=MuPK;
resQNew.SigmaPK=SigmaPK;
resQNew.Entropy_Marg_Agent1=Emlogm_distmarg_agent1;
resQNew.Entropy_Marg_Agent2=Emlogm_distmarg_agent2;





