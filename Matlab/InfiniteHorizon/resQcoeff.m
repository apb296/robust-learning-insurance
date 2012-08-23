function resQcoeff=resQcoeff(coeff,Q,Para)
Y=Para.Y;
delta=Para.delta;
c=coeff;
VGridSize=Para.VGridSize;
VGrid=Para.VGrid;
ctol=Para.ctol;
grelax=Para.grelax;
      for z=1:Para.ZSize
        
    for v=1:VGridSize
     res=EUSol(z,VGrid(z,v),Para);
        ConsEU0(v,z)=res.alpha1*Para.Y(z);  
       lambda0(z,v) = -funeval(c(z,:)',Q(z),VGrid(z,v),1);
options = optimset('MaxFunEvals', 5000*length(ConsEU0(v,z)),'Display','off','TolFun',1e-5);
   Cons(v,z)=fsolve(@(cons) resQc(cons,c,z,v,Q,Para),ConsEU0(v,z),options);
   %lambda=(der_u(Cons(v,z))/der_u(Y(z)-Cons(v,z)));
   lambda=lambda0(z,v);
   kappadiff=100;
   for zstar=1:Para.ZSize
    res=EUSol(zstar,VGrid(zstar,v),Para);
       VStar(zstar)=res.V2;
   end
   
   kappa=lambda;
   ctr=0;
   %tic
   while kappadiff>ctol
       ctr=ctr+1;
   for zstar=1:Para.ZSize
       vstar0=VStar(zstar);
   options = optimset('MaxFunEvals', 5000*length(vstar0),'Display','off','TolFun',1e-5);
   VStar(zstar)=fsolve(@(vstar) resQVstar(vstar,c,Q,zstar,kappa,Para),vstar0,options);
   QStar(zstar)=funeval(c(zstar,:)',Q(zstar),VStar(zstar));
   end
   % update kappa
   theta1=Para.Theta(1,1);
  EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,Para.m));
  EVStar=sum(exp(-VStar/theta1).*Para.P(z,:,Para.m)); 
  %kappanew=log(lambda*EQStar/EVStar);
  kappanew=lambda*EQStar/EVStar;
  kappaold=kappa;
  kappa=(1-grelax)*kappa+grelax*(kappanew);
  kappadiff=abs(kappaold-kappa);
  kappaHist(ctr)=kappa;
   end
   ctr;
   %toc
   for zstar=1:Para.ZSize
       vstar0=VStar(zstar);
   options = optimset('MaxFunEvals', 5000*length(vstar0),'Display','off','TolFun',1e-5);
   VStar(zstar)=fsolve(@(vstar) resQVstar(vstar,c,Q,zstar,kappa,Para),vstar0,options);
   QStar(zstar)=funeval(c(zstar,:)',Q(zstar),VStar(zstar));
   end
   EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,Para.m));
QNew(z,v)=u(Cons(v,z))-delta*theta1*log(EQStar);   
    end
    cNew(z,:)=funfitxy(Q(z),VGrid(z,:)',QNew(z,:)');
end
resQcoeff=sum(abs(coeff-cNew));
end
