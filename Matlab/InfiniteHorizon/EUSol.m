function res=EUSol(z,v,Para)
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
options = optimset('MaxFunEvals', 5000,'Display','off','TolFun',1e-7);

alpha2=fsolve(@(alpha) resCalcVEU(alpha,z,v,Para),.5,options);
% check if alpha2 <1
alpha2=max(min(alpha2,.9999),1-.99999);
alpha1=1-alpha2;

for i=1:ZSize
    for j=1:ZSize
        A(i,j)=-delta*P(i,j,m_true);
    end
end

for i=1:ZSize
A(i,i)=1-delta*P(i,i,m_true);
end

V1=inv(A)*u(alpha1*Y,ra);
V2=inv(A)*u(alpha2*Y,ra);

res.V1=V1;
res.V2=V2;
res.alpha1=alpha1;
res.lambda=(alpha1/(1-alpha1))^(-ra);
end
