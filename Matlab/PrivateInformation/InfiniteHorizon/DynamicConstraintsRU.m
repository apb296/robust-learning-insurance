% This program computes the Dynamic Incentive and Promise Keeping
% Constraints for the ambiguity case. It also computes the gradients
 function [CINQ, CEQ,  gradCINQ, gradCEQ ] = DynamicConstraintsRU(x,v0,Para,coeff,Q)
% function [CINQ, CEQ ] = DynamicConstraintsRU(x,v0,Para,coeff,Q)
% v0 is the exante promised utility
% z_ is the state previous period
% These both are the state variables for the Optimization.
% c(1),c(2) are components of the consumption plan for z_1 and z_2
% bar_vstar(z), are the agent 2 specific means of the continuation plans

% get components from x
c=x(1:2);
bar_vstar=x(3:4);


% get components from Para struc
pl=Para.pl;
ph=Para.ph;
ra=Para.ra;
beta=Para.beta;
y=Para.y;
Delta=Para.Delta;
Theta=Para.Theta;
theta_11=Theta(1,1);
theta_21=Theta(2,1);

lambdastar=-funeval(coeff,Q,bar_vstar',1);
Qstar=funeval(coeff,Q,bar_vstar',0);
[~,V,~,tilde_p0_agent_2] =ComputeValuesDistProb(c,bar_vstar,Qstar,ra,beta,pl,ph,y,theta_11,theta_21);


% Lastly we compute the gradient of the value function with each of the
% control variable - c1,c2,v*_1(1),v*_1(2), v*_2(1) v*_2(2)





%% Promisekeeping for Agent 2

CEQ=V-v0;
%CEQ=(u(y-c,ra)+beta*bar_vstar)*P(z_,:)'-v0;
gradCEQ=[-der_u(y-c(1),ra)*tilde_p0_agent_2(1) -der_u(y-c(2),ra)*tilde_p0_agent_2(2) beta*tilde_p0_agent_2(1) beta*tilde_p0_agent_2(2)]';

%% Incentive Constraints. Note the convention - I am writing the constraints as g(x)<=0

% 1) Agent 1, z=z_1
IC_1_1 = u(c(1),ra)-u(c(2)-Delta,ra)+beta*(Qstar(1)-Qstar(2));
% 2) Agent 1, z=z_2
IC_1_2 = u(c(2),ra)-u(c(1)+Delta,ra)+beta*(Qstar(2)-Qstar(1));
% 3) Agent 2, z=z_1
IC_2_1 = u(y-c(1),ra)-u(y-c(2)+Delta,ra)+beta*(bar_vstar(1)-bar_vstar(2));
% 4) Agent 2, z=z_2
IC_2_2 = u(y-c(2),ra)-u(y-c(1)-Delta,ra)+beta*(bar_vstar(2)-bar_vstar(1));

%CINQ=-[IC_1_1 IC_1_2 IC_2_1 IC_2_2 c(2)-c(1)];
CINQ=-[IC_1_1 IC_1_2 IC_2_1 IC_2_2];

% This computes the gradient on the inequality constraints  -  the rows are
% the constraints and the columns are the control variables


gradCINQ=-[der_u(c(1),ra) -der_u(c(2)-Delta,ra) -beta*lambdastar(1)    beta*lambdastar(2) ;
    
-der_u(c(1)+Delta,ra) der_u(c(2),ra) beta*lambdastar(1)    -beta*lambdastar(2) ;

-der_u(y-c(1),ra) der_u(y-c(2)+Delta,ra) beta    -beta ;

der_u(y-c(1)-Delta,ra) -der_u(y-c(2),ra) -beta    beta ;

%-1 1 0 0

]';


end



