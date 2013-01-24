function [res,user,iflag] = resFOC(n,x,user,iflag)
% vv0 is the exante promised utility
% zz_ is the state previous period
% These both are the state variables for the Optimization.
% c(1),c(2) are components of the consumption plan for zz_1 and zz_2
% bar_vstar(z), are the agent 2 specific means of the continuation plans
global flagcons PPara  vv0 zz_;
% get components from x
c=x(1:2);
bar_vstar=x(3:4);
mu=zeros(1,2);
mu=x(5:6);
% Note that mu(i) is Agent i's IC multiplier
lambda=x(7);


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
vstarRUbounds=PPara.vstarRUbounds;
CheckLowerBouds_bar_vstar=find(bar_vstar-vstarRUbounds(1,:)<0);
CheckUpperBouds_bar_vstar=find(vstarRUbounds(2,:)-bar_vstar<0);

CheckLowerBouds_c=find(c<0);
CheckUpperBouds_c=find(c > y-Delta);

if length([CheckLowerBouds_c  CheckUpperBouds_c  CheckLowerBouds_bar_vstar CheckUpperBouds_bar_vstar]) ==0

% Terminal Period 
%% This section computes the multiplier associated with PK and the value function in the terminal period corresponding to guessed bar_vstar. Note that the envelope condition links lambdastar=Qstar_v(vstar,z)
lambdastar=zeros(2,2);
for zTrue=1:2 % true state
    for zReported=1:2 %reprted state
        cstar0=y-u_inv(bar_vstar(zReported),ra);
        options=optimset('Display','off');
        
        % This solves the promise keeping for agent 2 in the terminal state
        % for vstar(z)
        try
        cstar = fzero(@(cstar) TerminalPKRU(cstar,bar_vstar(zReported),zTrue,PPara),[.001 y-Delta-.001],options);
        catch exception
            disp('fzero failed')
            bar_vstar(zReported)
        end
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
      % Now we compute the terminal utility of agent 1 a v*(z'),z)
      
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
MeanExp2=P(zz_,1)*(ExpU21)+P(zz_,2)*(ExpU22);

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


%% Promisekeeping for Agent 2

CEQ=-theta_21*log(MeanExp2)-vv0;

% gradient of the OBJ function

gradQ=-[der_u(c(1),ra)*tilde_p0_agent_1(1) der_u(c(2),ra)*tilde_p0_agent_1(2) -lambdastar(1,1)*delta*tilde_p0_agent_1(1) -delta*tilde_p0_agent_1(2)*lambdastar(2,2)];



%CEQ=(u(y-c,ra)+delta*bar_vstar)*P(zz_,:)'-vv0;
% gradient of the PK constraint
gradCEQ=[-der_u(y-c(1),ra)*tilde_p0_agent_2(1) -der_u(y-c(2),ra)*tilde_p0_agent_2(2) delta*tilde_p0_agent_2(1) delta*tilde_p0_agent_2(2)]';

%% Incentive Constraints

% 1) Agent 1, z=zz_2
switch flagcons
    case 2
IC_1_2 = u(c(2),ra)-u(c(1)+Delta,ra)+delta*(Qstar(2,2)-Qstar(1,2));
IC_2_1 =mu(2);
    case 1
        IC_1_2=mu(1);
IC_2_1 = u(y-c(1),ra)-u(y-c(2)+Delta,ra)+delta*(bar_vstar(1)-bar_vstar(2));
    otherwise
        IC_1_2 = u(c(2),ra)-u(c(1)+Delta,ra)+delta*(Qstar(2,2)-Qstar(1,2));
% 2) Agent 2, z=zz_1
IC_2_1 = u(y-c(1),ra)-u(y-c(2)+Delta,ra)+delta*(bar_vstar(1)-bar_vstar(2));
end

% This computes the gradient on the inequality constraints  -  the rows are
% the constraints and the columns are the control variables



gradIC=[
    
-der_u(c(1)+Delta,ra) der_u(c(2),ra) delta*lambdastar(1,2)    -delta*lambdastar(2,2) ;

-der_u(y-c(1),ra) der_u(y-c(2)+Delta,ra) delta    -delta ;

]';



res=[gradQ'+lambda*gradCEQ-(mu*gradIC')'; IC_1_2;IC_2_1;CEQ];
else
res=abs(x)*100+10;
end

