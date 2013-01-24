function [V,gradV]=PKFullRiskSharing(x,Para)

% This program computes the Value function for the ambiguity
%  case. It also computes the gradients
% v0 is the exante promised utility
% z_ is the state previous period
% These both are the state variables for the Optimization.
% c(1),c(2) are components of the consumption plan for z_1 and z_2
% bar_vstar_agent_1(z),bar_vstar_agent_2(z) are the means of the continuation
% plans conditioned on the reported state z. These are the meands with
% respect to the agent specific distoreted measure


% get components from x
c(1)=x(1);
c(2)=x(2);
bar_vstar=x(3:4);

% get components from Para struc
pl=Para.pl;
ph=Para.ph;
ra=Para.ra;
beta=Para.beta;
y=Para.y;
Theta=Para.Theta;
theta_11=Theta(1,1);
theta_21=Theta(2,1);
%theta_agent,operator

Qstar=[1 1];
[~,V,~,tilde_p0_agent_2] =ComputeValuesDistProb(c,bar_vstar,Qstar,ra,beta,pl,ph,y,theta_11,theta_21);


% Lastly we compute the gradient of the value function with each of the
% control variable - c1,c2,v*_1(1),v*_1(2), v*_2(1) v*_2(2)





%% Promisekeeping for Agent 2

V=V;
%CEQ=(u(y-c,ra)+beta*bar_vstar)*P(z_,:)'-v0;
gradV=[-der_u(y-c(1),ra)*tilde_p0_agent_2(1) -der_u(y-c(2),ra)*tilde_p0_agent_2(2)  beta*tilde_p0_agent_2(1) beta*tilde_p0_agent_2(2)]';

end


