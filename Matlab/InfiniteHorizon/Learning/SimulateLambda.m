close all
clear Lambda
m(1)=1;
z(1)=1;
N=100
Lambda(1)=.2;
for i=2:N
    
    m_dist=P_M(m(i-1),:);
    m(i)=discretesample(m_dist, 1);
    z_dist=P(z(i-1),:,m(i-1));
    z(i)=discretesample(z_dist, 1);
   pi_m=[pi(i-1) 1-pi(i-1)];
 pi_m_star= P_M*squeeze(P(z(i-1),z(i),:)).*pi_m'/sum(P_M*squeeze(P(z(i-1),z(i),:)).*pi_m');
 pi(i)=pi_m_star(1);
Lambda(i)=funeval(LambdaStar_C(z(i),:)',FuncLambdaStar(z(i)),[ pi(i) Lambda(i-1)]);

end

%plot(Lambda)
hist(Lambda)