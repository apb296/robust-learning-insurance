
function [QNew]=ValueFunction(x,z,c,Q,Para)
%addpath(genpath('C:\Program Files\MATLAB\R2010b\toolbox\compecon2011'))
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
theta1=Para.Theta(1,1);
QStar=zeros(4,1)';
cons=x(1);
VStar(1)=x(2);
VStar(2)=x(2);
VStar(3)=x(3);
VStar(4)=x(3);
for zstar=1:ZSize
QStar(zstar)=funeval(c(zstar,:)',Q(zstar),VStar(zstar));
end
EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,Para.m));
QNew=u(cons,ra)-delta*theta1*log(EQStar); 
QNew=-QNew;
end

