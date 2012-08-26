function resQcoeff=resQcoeff2(coeff,Q,Para)
c(1,:)=coeff(1,:);
c(2,:)=coeff(1,:);
c(3,:)=coeff(2,:);
c(4,:)=coeff(2,:);

Y=Para.Y;
delta=Para.delta;
VGridSize=Para.VGridSize;
VGrid=Para.VGrid;
ctol=Para.ctol;
grelax=Para.grelax;
      

for z=1:Para.ZSize
               if (z==1 || z==3) 

    for v=1:VGridSize
     res=EUSol(z,VGrid(z,v),Para);
        ConsEU0=res.alpha1*Para.Y(z);  
       VStarEU0=res.V2';
       x0=[ConsEU0 VStarEU0];
options = optimset('MaxFunEvals', 5000*length(x0),'Display','off','TolFun',1e-5);
   x=fsolve(@(x) resQ(x,z,VGrid(z,v),c,Q,Para),x0,options);
 cons=x(1);
VStar=x(2:end);
theta1=Para.Theta(1,1);
for zstar=1:Para.ZSize
QStar(zstar)=funeval(c(zstar,:)',Q(zstar),VStar(zstar));
end
EQStar=sum(exp(-QStar/theta1).*Para.P(z,:,Para.m));
QNew(z,v)=u(cons)-delta*theta1*log(EQStar);   

    end
    
    cNew(z,:)=funfitxy(Q(z),VGrid(z,:)',QNew(z,:)');
    else
        cNew(z,:)=cNew(z-1,:);
    end    
    
    end
    cOld=c;

    
     
    
c=cOld*(1-grelax)+cNew*grelax;
resQcoeff=cOld-c;


end
