%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function evaluates the residuals in the FOC for the planners
% problem. We have 5 control variables - Consumption for agent 1 and
% Continuation values for Agent 2 for all possible future states

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
function [resQ,iflag]=resQNAG(n,x,iflag)
global Q c Para z pi v
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

if (and(cons<Y(z),cons>0))                                                  % Check for non negativity
    
    
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FOC with respect to vstar
        resVStar(zstar)=  dist_marg_agent1(zstar)*lambdastar(zstar)-lambda*dist_marg_agent2(zstar);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Promise keeping constraint. The consumption and continuation values
    % for agent 2 must satisfy the value v
    agent2_v=-theta2*log(exp(-(u(Y(z)-cons,ra)+delta*T1_agent2)/theta2)*([pi; 1-pi]));
    resV=agent2_v-v;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    
    resQ=[resVStar resV];
    
    
else
    
    %    if (or(cons<0,cons>Y(z)))
    resQ=[10 10 10 10 10].*abs(cons-Y(z))+abs(cons);
    %   end
end


if isreal(resQ)==0
    resQ=[10 10 10 10 10].*abs(resQ);
    %     disp('Complex values found...')
    %     disp(x)
    %     save('x_complex.mat','x');
    %disp(resQ)
end

end
