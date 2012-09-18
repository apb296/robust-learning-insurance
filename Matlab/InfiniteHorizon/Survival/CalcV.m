
function res =CalcV(V,alpha,Para)
Y=Para.Y;
theta_2=Para.theta_2;
YSize=length(Para.Y);
P2=Para.P2;
delta=Para.delta;
gamma=Para.gamma;
for y=1:YSize
res(y)=u(alpha*Y(y),gamma)-theta_2*delta*log(sum(exp(-V/theta_2).*squeeze(P2(y,:))'))-V(y);
end
