
function resQ=resQ(x,z,v,c,Q,Para)
%addpath(genpath('C:\Program Files\MATLAB\R2010b\toolbox\compecon2011'))
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
theta1=Para.Theta(1,1);


cons=x(1);
VStar(1)=x(2);
VStar(2)=x(2);
VStar(3)=x(3);
VStar(4)=x(3);
      
lambda=(der_u(cons)/der_u(Y(z)-cons));
if (and(cons<Y(z),cons>0))
for zstar=1:ZSize
lambdastar(zstar) = -funeval(c(zstar,:)',Q(zstar),VStar(zstar),1);
%res=EUSol(zstar,VStar(zstar),Para);
%lambdastar(zstar) = res.lambda;
QStar(zstar)=funeval(c(zstar,:)',Q(zstar),VStar(zstar));
%LLfactor(zstar)=exp(-(QStar(zstar)-VStar(zstar))/theta1);
Distfactor1(zstar)=exp(-QStar(zstar)/theta1);

Distfactor2(zstar)=exp(-VStar(zstar)/theta1);

end
EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,Para.m));
Distfactor1=Distfactor1./EQStar;

EVStar=sum(exp(-VStar/theta1).*Para.P(z,:,Para.m)); 
Distfactor2=Distfactor2./EVStar;
%resQVstar=lambdastar.*LLfactor-lambda*EQStar/EVStar;
%resQVstar=(lambdastar.*LLfactor*EVStar/EQStar)-lambda;
resQVstar=lambdastar.*Distfactor1-lambda*Distfactor2;
resV=u(Y(z)-cons)-theta1*delta*log(EVStar)-v;
%resV=lambda+funeval(c(z,:)',Q(z),v,1);


resQ=[resQVstar(1) resQVstar(3) resV ];
    
else
    
    %    if (or(cons<0,cons>Y(z)))
    resQ=[10 10 10].*abs(cons-Y(z))+abs(cons);
    %   end
end

if isreal(resQ)==0
    
    disp('Complex values at ')
    disp(x)
    disp(resQ)
    resQ=[10 10 10].*abs(resQ);
end
end

