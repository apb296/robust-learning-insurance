function res=res_c_static(c,z0,Para)
y=Para.y;
Delta=Para.Delta;
lambda=Para.lambda;
beta=Para.beta;
P=[beta 1-beta;1-beta beta];
ra=Para.ra;
theta=Para.theta;

% tilde_p_agent_1
tilde_p_agent_1(1)=P(z0,1)*exp(-u(c,ra)/theta);
tilde_p_agent_1(2)=P(z0,2)*exp(-u(c+Delta,ra)/theta);
tilde_p_agent_1=tilde_p_agent_1./sum(tilde_p_agent_1);


% tilde_p_agent_2
tilde_p_agent_2(1)=P(z0,1)*exp(-u(y-c,ra)/theta);
tilde_p_agent_2(2)=P(z0,2)*exp(-u(y-c-Delta,ra)/theta);
tilde_p_agent_2=tilde_p_agent_2./sum(tilde_p_agent_2);


% LHS

Num=tilde_p_agent_1(1)*der_u(c,ra)-lambda*tilde_p_agent_2(1)*der_u(y-c,ra);
Den=tilde_p_agent_1(2)*der_u(c+Delta,ra)-lambda*tilde_p_agent_2(2)*der_u(y-c-Delta,ra);
LHS=Num;



% RHS

RHS=-Den;

res=LHS-RHS;

end
