function [Q,gradQ]=GetValue(x,z,pi,c,Q,Para)
cons=x(1);
VStar(1)=x(2);
VStar(2)=x(3);
VStar(3)=x(4);
VStar(4)=x(5);

delta=Para.delta;
ZSize=Para.ZSize;
P=Para.P;
P_M=Para.P_M;
theta1=Para.Theta(1,1);
theta2=Para.Theta(1,2);
PiMin=Para.PiMin;
PiMax=Para.PiMax;
MSize=Para.MSize;
ra=Para.RA;
   
    
  
    
    pi_m=[pi 1-pi];
    for zstar=1:ZSize
        % Updating the filter using bayes law (checked the code with
        % HMMFilter.m)
        
        for m_star_indx=1:MSize
            Num=0;
            for m_indx=1:MSize
                %Num=Num+P_Z(z(i-1),z(i),m_star_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx,i-1);
                Num=Num+P(z,zstar,m_indx)*P_M(m_indx,m_star_indx)*pi_m(m_indx);
            end
            pi_m(m_star_indx)= Num;
        end
        D=sum(pi_m(:));
        pi_m_star= pi_m(:)/D;
        %pi_m_star= P_M*squeeze(P_Z(z(i-1),z(i),:)).*pi_m(:,i-1)/sum(P_M*squeeze(P_Z(z(i-1),z(i),:)).*pi_m(:,i-1));
        
        %pistar(zstar)=pi*P(z,zstar,1)/(pi*P(z,zstar,1)+(1-pi)*P(z,zstar,2))   ;
        
        
        
        pistar(zstar)=pi_m_star(1);
        %%
        
        % This adjustment keeps the pi within the bounds of state space
        
        if pistar(zstar)<PiMin
            pistar(zstar)=PiMin;
        end
        if pistar(zstar)>PiMax
            pistar(zstar)=PiMax;
        end
        % Using envelope theorem to compute lambda(zstar)
        lambdastar(zstar) = -funeval(c(zstar,:)',Q(zstar),[ pistar(zstar) VStar(zstar)],[0 1]);
        
        % Computing QStar using the guess for the value function (cheb polynomials
        % with coeffecient c)
        
        QStar(zstar)=funeval(c(zstar,:)',Q(zstar),[ pistar(zstar) VStar(zstar)]);
        
        % This computes the model specific distorted transition given the values
        % for both the agent. the first step computes the un normalized probability
        for m=1:MSize
            p_tilde_agent1(zstar,m)=P(z,zstar,m)*exp(-QStar(zstar)/theta1);
            
            
        end
        
        
        
        
        
    end
    % normalize the distorted probabilities for adding up to 1
    for m=1:MSize
        D_agent1(m)= sum(p_tilde_agent1(:,m));
        for zstar=1:ZSize
            
            p_tilde_agent1(zstar,m)=p_tilde_agent1(zstar,m)/D_agent1(m);
        end
    end
    
    % Now compute the T1 operator for both the agents. Note that this iperator
    % takes the distorted expectation for the value tomorrow given a particular
    % model. Note that it does not include the discounting
    
    for m=1:MSize
        T1_agent1(m)=-theta1*log(sum(P(z,:,m).*exp(-QStar/theta1)))   ;
    end
    % Now compute the distorted prior (pi tilde) for model 1 using the
    % value functions and consumption today for both the agents
    
    
    pi_tilde_agent1_model1 = pi*exp(-(u(cons,ra)+delta*T1_agent1(1))/theta2);
    pi_tilde_agent1_model2 =(1-pi)*exp(-(u(cons,ra)+delta*T1_agent1(2))/theta2);
    pi_tilde_agent1=pi_tilde_agent1_model1/(pi_tilde_agent1_model1+pi_tilde_agent1_model2);
    
    
    % Now compute the distorted marginal for zstar across models using
    % the distorted prior and distorted transitions. Note that this is
    % agent specific.
    
    for zstar=1:ZSize
        dist_marg_agent1(zstar)= pi_tilde_agent1*p_tilde_agent1(zstar,1)+(1-pi_tilde_agent1)*p_tilde_agent1(zstar,2);
      
    end
Q=-(-theta2*log(exp(-(u(cons,ra)+delta*T1_agent1)/theta2)*([pi; 1-pi])));
gradQ=-[der_u(cons,ra) -delta*dist_marg_agent1.*lambdastar];
end
