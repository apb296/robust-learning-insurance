
function resQ=resQ(VStar,cons,c,Q,Para)
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
lambda=(der_u(cons)/der_u(Y(z)-cons));
for zstar=1:ZSize
lambdastar(zstar) = -funeval(c(zstar,:)',Q(zstar),vstar,1);
QStar(zstar)=funeval(c(zstar,:)',Q(zstar),vstar);
LLfactor(zstar)=exp(-(qstar-vstar)/theta1);

end
EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,Para.m));
EVStar=sum(exp(-VStar/theta1).*Para.P(z,:,Para.m)); 
resQVstar=lambdastar.*LLfactor-lambda*EQStar/EVStar;
resV=u(Y(z)-cons)-theta1*log(EVStar)-v;
resQ=[resQV resV];