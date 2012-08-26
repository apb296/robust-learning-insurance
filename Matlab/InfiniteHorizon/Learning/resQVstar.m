function resQVstar=resQVstar(vstar,c,der_c,Q,DerQ,zstar,kappa,Para)
theta1=Para.Theta(1,1);
lambdastar = -funeval(der_c(zstar,:)',DerQ(zstar),vstar);
qstar=funeval(c(zstar,:)',Q(zstar),vstar);
LLfactor=exp(-(qstar-vstar)/theta1);
%resQVstar=log(lambdastar)+log(LLfactor)-kappa;
resQVstar=lambdastar*LLfactor-kappa;
end
