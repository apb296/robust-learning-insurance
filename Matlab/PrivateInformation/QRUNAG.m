function  [mode, Q, gradQ, user] = QRUNAG(mode, n, x, objgrd, nstate, user)

% This program computes the Value function for the ambiguity
%  case. It also computes the gradients
% vv0 is the exante promised utility
% zz_ is the state previous period
% These both are the state variables for the Optimization.
% c(1),c(2) are components of the consumption plan for zz_1 and zz_2
% bar_vstar_agent_1(z),bar_vstar_agent_2(z) are the means of the continuation
% plans conditioned on the reported state z. These are the meands with
% respect to the agent specific distoreted measure

global PPara vv0 zz_;
mode=int64(2);
% get components from x
c=x(1:2);
bar_vstar=x(3:4);

% get components from PPara struc
P=PPara.P(:,:,PPara.m_true);
ra=PPara.RA;
delta=PPara.delta;
y=PPara.y;
sl=PPara.sl;
sh=PPara.sh;
Delta=y*(sh-sl);
Theta=PPara.Theta;
theta_11=Theta(1,1);
theta_21=Theta(2,1);
%theta_agent,operator








% Terminal Period 
%% This section computes the multiplier associated with PK and the value function in the terminal period corresponding to guessed bar_vstar. Note that the envelope condition links lambdastar=Qstar_v(vstar,z)
lambdastar=zeros(2,2);
for zTrue=1:2 % true state
    for zReported=1:2 %reprted state
        cstar0=y-u_inv(bar_vstar(zReported),ra);
        options=optimset('Display','off');
        
        % This solves the promise keeping for agent 2 in the terminal state
        % for vstar_1(z)
        
        cstar = fzero(@(cstar) TerminalPKRU(cstar,bar_vstar(zReported),zTrue,PPara),[.001 y-Delta-.001],options);
        
     %Now we use the consumption plan in the terminal period (c*,c*+Delta) to construct the worst case distibutions for both the agents
     
tilde_p_agent_1(1)=P(zTrue,1)*exp(-u(cstar,ra)/theta_11);
tilde_p_agent_1(2)=P(zTrue,2)*exp(-u(cstar+Delta,ra)/theta_21);
tilde_p_agent_1=tilde_p_agent_1./sum(tilde_p_agent_1);


% tilde_p_agent_2
tilde_p_agent_2(1)=P(zTrue,1)*exp(-u(y-cstar,ra)/theta_21);
tilde_p_agent_2(2)=P(zTrue,2)*exp(-u(y-cstar-Delta,ra)/theta_21);
tilde_p_agent_2=tilde_p_agent_2./sum(tilde_p_agent_2);

        
        
        
        
        % From the FOC of the terminal period we can back out lambda*(v*_1(z),z)
        
        lambdastar(zReported,zTrue)=[der_u(cstar,ra) der_u(cstar+Delta,ra)]*tilde_p_agent_1'/([der_u(y-cstar,ra) der_u(y-cstar-Delta,ra)]*tilde_p_agent_2');
      % Now we compute the terminal utility of agent 1 a v*_1(z'),z)
      
        Qstar(zReported,zTrue)=-theta_11*log(P(zTrue,1)*exp(-u(cstar,ra)/theta_11)+P(zTrue,2)*exp(-u(cstar+Delta,ra)/theta_11));

    end
end


% exp(-(u+delta Q*)/theta) for both the agents
ExpU11=exp(-(u(c(1),ra)+delta*Qstar(1,1))/theta_11);
ExpU12=exp(-(u(c(2),ra)+delta*Qstar(2,2))/theta_11);
ExpU21=exp(-(u(y-c(1),ra)+delta*bar_vstar(1))/theta_21);
ExpU22=exp(-(u(y-c(2),ra)+delta*bar_vstar(2))/theta_21);


% Mean of the exponentiated utility
MeanExp1=P(zz_,1)*(ExpU11)+P(zz_,2)*(ExpU12);

% this is negative of the time 0 utility for agent 1. Note that we have
% done the risk adjustem and applied a minus sign to the result
Q=theta_11*log(MeanExp1);


% Now we compute the disrtoted distribution for the computing the ex ante
% utilities for both agents
tilde_p0_agent_1(1)=P(zz_,1)*exp(ExpU11);
tilde_p0_agent_1(2)=P(zz_,2)*exp(ExpU12);
tilde_p0_agent_1=tilde_p0_agent_1./sum(tilde_p0_agent_1);


tilde_p0_agent_2(1)=P(zz_,1)*exp(ExpU21);
tilde_p0_agent_2(2)=P(zz_,2)*exp(ExpU22);
tilde_p0_agent_2=tilde_p0_agent_2./sum(tilde_p0_agent_2);        


% Lastly we compute the gradient of the value function with each of the
% control variable - c1,c2,v*_1(1),v*_1(2), v*_2(1) v*_2(2)


gradQ=-[der_u(c(1),ra)*tilde_p0_agent_1(1) der_u(c(2),ra)*tilde_p0_agent_1(2) -lambdastar(1,1)*delta*tilde_p0_agent_1(1) -delta*tilde_p0_agent_1(2)*lambdastar(2,2)];
if ~isreal(Q) || ~isreal(gradQ)
    Q=abs(Q)+100;
    gradQ=abs(gradQ)*1000;
end


