
function res =CalcV(V,alpha,Para,agent)
if nargin==3
    agent=2;
end
switch agent
    case 1
        P=Para.P1;
        theta=Para.theta_1;
    case 2
        P=Para.P2;
        theta=Para.theta_2;
end

Y=Para.Y;
YSize=length(Para.Y);
delta=Para.delta;
gamma=Para.gamma;
for y=1:YSize
res(y)=u(alpha*Y(y),gamma)-theta*delta*log(sum(exp(-V/theta).*squeeze(P(y,:))'))-V(y);
end
