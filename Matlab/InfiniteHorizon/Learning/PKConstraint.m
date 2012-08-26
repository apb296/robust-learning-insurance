function [CInq,PK,gradCInq,gradPK]=PKConstraint(x,z,v,pi,Para)
CInq=[];
gradCInq=[];
cons=x(1);
VStar(1)=x(2);
VStar(2)=x(3);
VStar(3)=x(4);
VStar(4)=x(5);

Y=Para.Y;
delta=Para.delta;
ZSize=Para.ZSize;
P=Para.P;
theta1=Para.Theta(1,1);
theta2=Para.Theta(1,2);
MSize=Para.MSize;
ra=Para.RA;

    
    
     for zstar=1:ZSize
       
       
        
    
        
        % This computes the model specific distorted transition given the values
        % for both the agent. the first step computes the un normalized probability
        for m=1:MSize
            p_tilde_agent2(zstar,m)=P(z,zstar,m)*exp(-VStar(zstar)/theta1);
        end
        
        
        
        
        
    end
    % normalize the distorted probabilities for adding up to 1
    for m=1:MSize
        
        D_agent2(m)= sum(p_tilde_agent2(:,m));
        for zstar=1:ZSize
            p_tilde_agent2(zstar,m)=p_tilde_agent2(zstar,m)/D_agent2(m);
        end
    end
    
    % Now compute the T1 operator for both the agents. Note that this iperator
    % takes the distorted expectation for the value tomorrow given a particular
    % model. Note that it does not include the discounting
    
    for m=1:MSize
      
        T1_agent2(m)=-theta1*log(sum(P(z,:,m).*exp(-VStar/theta1)))   ;
    end
    % Now compute the distorted prior (pi tilde) for model 1 using the
    % value functions and consumption today for both the agents
    
    
   
    pi_tilde_agent2_model1 = pi*exp(-(u(Y(z)-cons,ra)+delta*T1_agent2(1))/theta2);
    pi_tilde_agent2_model2 =(1-pi)*exp(-(u(Y(z)-cons,ra)+delta*T1_agent2(2))/theta2);
    pi_tilde_agent2=pi_tilde_agent2_model1/(pi_tilde_agent2_model1+pi_tilde_agent2_model2);
    
    % Now compute the distorted marginal for zstar across models using
    % the distorted prior and distorted transitions. Note that this is
    % agent specific.
    
    for zstar=1:ZSize
        dist_marg_agent2(zstar)=pi_tilde_agent2*p_tilde_agent2(zstar,1)+(1-pi_tilde_agent2)*p_tilde_agent2(zstar,2);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Promise keeping constraint. The consumption and continuation values
    % for agent 2 must satisfy the value v
    agent2_v=-theta2*log(exp(-(u(Y(z)-cons,ra)+delta*T1_agent2)/theta2)*([pi; 1-pi]));
    PK=agent2_v-v;
    PK=-PK;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%
    %Gradient of PK
    gradPK=[der_u(Y(z)-cons,ra) delta*dist_marg_agent2]';
    gradPK=-gradPK;