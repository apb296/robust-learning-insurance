function V1=EUSol(v,Para)
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
options = optimset('MaxFunEvals', 5000,'Display','off','TolFun',1e-5);
alpha2=fsolve(@(alpha) resCalcVEU(alpha,z,v,Para),.2);
alpha1=1-alpha2;
V1=u(alpha1*Y(z))/(1-delta);
end
