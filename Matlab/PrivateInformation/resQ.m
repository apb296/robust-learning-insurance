function res=resQ(x,z,v,Para)

% x contains the control variables  - consumption , continuation value in
% the z=2 (v^*[zstar_2]) and the Lagrange Multiplier Mu on the IC
% constraint





c=x(1);
VStar(2)=x(2);
Mu=x(3);

y=Para.y;
P=Para.P;
theta_agent_1_z=Para.Theta(1,1);
theta_agent_2_z=Para.Theta(2,1);
theta_agent_1_m=Para.Theta(1,2);
theta_agent_2_m=Para.Theta(2,2);
delta=Para.delta;
ra=Para.RA;
pi_agent_1=Para.Pi(:,1);
pi_agent_2=Para.Pi(:,2);
sh=Para.sh;
sl=Para.sl;

if (c<y || c>0)
    
% Using the IC constraint to backout VStar(1)
VStar(1)=u(u_inv(VStar(2),ra)+y*(sh-sl),ra);

for zstar=1:Para.ZSize
 % terminal consumption for agent 1 given VStar
 
cStar(zstar)=y-u_inv(VStar(zstar),ra);

%  terminal utility for agent 1 given cStar

QStar(zstar)=u(cStar(zstar),ra);

% terminal ratio of marginal utilities 
lambdastar(zstar)=der_u(cStar(zstar),ra)/der_u(y-cStar(zstar),ra);

for m=1:Para.MSize
    % Unnormalized distorted transitions for agent 1 and agent 2
DistP_agent_1_un(zstar,m)=P(z,zstar,m)*exp(-QStar(zstar)/theta_agent_1_z);
DistP_agent_2_un(zstar,m)=P(z,zstar,m)*exp(-VStar(zstar)/theta_agent_2_z);


end
end

for m=1:Para.MSize
 

% Model specific robust utility for both the agents

Q(m)=u(c,ra)-theta_agent_1_z*delta*log(sum(P(z,:,m).*exp(-QStar/theta_agent_1_z)));
V(m)=u(y-c,ra)-theta_agent_2_z*delta*log(sum(P(z,:,m).*exp(-VStar/theta_agent_2_z)));
% Distorted prior using model specific utility for both the agents

DistPi_agent_1_un(m)=pi_agent_1(m)*exp(Q(m)/theta_agent_1_m);
DistPi_agent_2_un(m)=pi_agent_2(m)*exp(V(m)/theta_agent_2_m);
end


% Noralizing distorted transitions for both the agents
DistP_agent_1=DistP_agent_1_un./repmat(sum(DistP_agent_1_un),Para.MSize,1);
DistP_agent_2=DistP_agent_2_un./repmat(sum(DistP_agent_2_un),Para.MSize,1);
% Noralizing distorted priors for both the agents
DistPi_agent_1=DistPi_agent_1_un./sum(DistPi_agent_1_un);
DistPi_agent_2=DistPi_agent_2_un./sum(DistPi_agent_2_un);

% Computing the model averaged marginals for both the agents
DistMarg_agent_1=DistP_agent_1*DistPi_agent_1';
DistMarg_agent_2=DistP_agent_2*DistPi_agent_2';

% FOC w.r.t c

lambda=der_u(c,ra)/der_u(y-c,ra);

% FOC w.r.t VStar1
res_vstar_1=-delta*DistMarg_agent_1(1)*lambdastar(1)+delta*lambda*DistMarg_agent_2(1)+Mu;
%res_vstar_1=DistMarg_agent_1(1)*der_u(cStar(1),ra)-der_u(y-cStar(1),ra)*lambda*DistMarg_agent_2(1)+Mu;
% FOC w.r.t VStar2
%res_vstar_2=DistMarg_agent_1(2)*der_u(cStar(1)+y*(sh-sl),ra)-lambda*der_u(y-cStar(1)-y*(sh-sl),ra)*DistMarg_agent_2(2)-Mu;
res_vstar_2=-delta*DistMarg_agent_1(2)*lambdastar(2)+delta*lambda*DistMarg_agent_2(2)-Mu*(der_u(y-cStar(2)+y*(sh-sl),ra)/(der_u(y-cStar(2),ra)));

% Promise keeping for agent 2
res_v =-theta_agent_2_m*log(sum(pi_agent_2'.*exp(-V/theta_agent_2_m)))-v;

res=[res_vstar_1 res_vstar_2 res_v];

else
    res=[10 10 10]*abs(c)+abs(y-c);
end

end
