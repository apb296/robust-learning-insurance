function [Q,V,tilde_p0_agent_1,tilde_p0_agent_2] = ComputeValuesDistProb(c,bar_vstar,Qstar,ra,beta,pl,ph,y,theta_11,theta_21)


U11=u(c(1),ra)+beta*Qstar(1);
U12=u(c(2),ra)+beta*Qstar(2);
U21=u(y-c(1),ra)+beta*bar_vstar(1);
U22=u(y-c(2),ra)+beta*bar_vstar(2);


Q=-theta_11*log(pl(1)*(exp(-U11/theta_11))+ph(1)*(exp(-U12/theta_11)));
V=-theta_21*log(pl(2)*(exp(-U21/theta_21))+ph(2)*(exp(-U22/theta_21)));


% Now we compute the disrtoted distribution for the computing the ex ante
% utilities for both agents
tilde_p0_agent_1(1)=1/(1+(ph(1)/pl(1))*(exp((U11-U12)/theta_11)));
tilde_p0_agent_1(2)=1/(1+(pl(1)/ph(1))*(exp((U12-U11)/theta_11)));
tilde_p0_agent_2(1)=1/(1+(ph(2)/pl(2))*(exp((U21-U22)/theta_21)));
tilde_p0_agent_2(2)=1/(1+(pl(2)/ph(2))*(exp((U22-U21)/theta_21)));



end
