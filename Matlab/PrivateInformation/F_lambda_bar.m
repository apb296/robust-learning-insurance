function F_lambda_bar=F_lambda_bar(lambda,z0,Para)
 theta=Para.theta;
y=Para.y;
Delta=Para.Delta;
beta=Para.beta;
P=[beta 1-beta;1-beta beta];
ra=Para.ra;
theta=Para.theta;
Para.theta=100000000;
Para.lambda=lambda;
cMin=Para.cMin;
cMax=Para.cMax;
c=fzero(@(c) res_c_static(c,z0,Para),[cMin cMax]);
tilde_p_agent_1(1)=P(z0,1)*exp(-u(c,ra)/theta);
tilde_p_agent_1(2)=P(z0,2)*exp(-u(c+Delta,ra)/theta);
tilde_p_agent_1=tilde_p_agent_1./sum(tilde_p_agent_1);
% 
% 
 
 tilde_p_agent_2(1)=P(z0,1)*exp(-u(y-c,ra)/theta);
 tilde_p_agent_2(2)=P(z0,2)*exp(-u(y-c-Delta,ra)/theta);
 tilde_p_agent_2=tilde_p_agent_2./sum(tilde_p_agent_2);

Num=tilde_p_agent_1(1)*der_u(c,ra)-lambda*tilde_p_agent_2(1)*der_u(y-c,ra);
Den=tilde_p_agent_1(2)*der_u(c+Delta,ra)-lambda*tilde_p_agent_2(2)*der_u(y-c-Delta,ra);
LHS=Num;



% RHS

RHS=-Den;
%F_lambda_bar=LHS-RHS;
F_lambda_bar=lambda*tilde_p_agent_2(1)*der_u(y-c,ra);

end
