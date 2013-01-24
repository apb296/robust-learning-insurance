function [Q,gradQ]=QRU(x,Para,coeff,Q)

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
c=x(1:2);
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

lambdastar=-funeval(coeff,Q,bar_vstar',1);
Qstar=funeval(coeff,Q,bar_vstar',0);
[Q,~,tilde_p0_agent_1,~] = ComputeValuesDistProb(c,bar_vstar,Qstar,ra,beta,pl,ph,y,theta_11,theta_21);
Q=-Q;
gradQ=-[der_u(c(1),ra)*tilde_p0_agent_1(1) der_u(c(2),ra)*tilde_p0_agent_1(2) -lambdastar(1)*beta*tilde_p0_agent_1(1) -beta*tilde_p0_agent_1(2)*lambdastar(2)];
if ~isreal(Q) || ~isreal(gradQ)
    Q=abs(Q)+100;
    gradQ=abs(gradQ)*1000;
end


