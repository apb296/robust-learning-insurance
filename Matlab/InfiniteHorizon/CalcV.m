
function res =CalcV(V,alpha,Para)
Y=Para.Y;
Theta=Para.Theta;
theta1=Theta(1,1);
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
ra=Para.RA;
for z=1:ZSize
res(z)=u(alpha*Y(z),ra)-theta1*delta*log(sum(exp(-V/theta1).*squeeze(P(z,:,m_true))'))-V(z);
end
