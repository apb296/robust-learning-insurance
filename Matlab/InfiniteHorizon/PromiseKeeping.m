
function [cinq,ceq]=PromiseKeeping(x,v,z,Para)
cinq=[];
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
P=Para.P;
theta1=Para.Theta(1,1);

cons=x(1);
VStar(1)=x(2);
VStar(2)=x(2);
VStar(3)=x(3);
VStar(4)=x(3);
EVStar=sum(exp(-VStar/theta1).*Para.P(z,:,Para.m)); 
ceq=u(Y(z)-cons,ra)-theta1*delta*log(EVStar)-v;
end

