function [ res] = ResidualAllConstraintsBinding(xv,Para,coeff,Q)

% get components from x
c=xv(1:2);
bar_vstar=xv(3:4);
v0=xv(5);

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

if min(bar_vstar)>0
% Lastly we compute the gradient of the value function with each of the
% control variable - c1,c2,v*_1(1),v*_1(2), v*_2(1) v*_2(2)





%% Promisekeeping for Agent 2

CEQ=V-v0;

%% Incentive Constraints. Note the convention - I am writing the constraints as g(x)<=0

% 1) Agent 1, z=z_1
IC_1_1 = u(c(1),ra)-u(c(2)-Delta,ra)+beta*(Qstar(1)-Qstar(2));
% 2) Agent 1, z=z_2
IC_1_2 = u(c(2),ra)-u(c(1)+Delta,ra)+beta*(Qstar(2)-Qstar(1));
% 3) Agent 2, z=z_1
IC_2_1 = u(y-c(1),ra)-u(y-c(2)+Delta,ra)+beta*(bar_vstar(1)-bar_vstar(2));
% 4) Agent 2, z=z_2
IC_2_2 = u(y-c(2),ra)-u(y-c(1)-Delta,ra)+beta*(bar_vstar(2)-bar_vstar(1));

CINQ=-[IC_1_1 IC_1_2 IC_2_1 IC_2_2 ];


res=[CEQ CINQ];

else
    res=abs(xv)*10+100;
end

end

