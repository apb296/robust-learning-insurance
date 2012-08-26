% Redo the optimization using fmincon
VSuperMax=Para.VSuperMax;
xFOC=x;
xInit=xFOC;
cons=x(1);
VStar(1)=x(2);
VStar(2)=x(3);
VStar(3)=x(4);
VStar(4)=x(5);
if cons > Y(z)
    xInit(1)=Y(z)*.99;
elseif cons < 0
    xInit(1)=.01;
end
xInit(2:5)=min(VStar,VSuperMax);


    opts = optimset('MaxIter',3000, 'MaxFunEvals',3000,...
      'TolX', Para.ctol, 'TolFun', Para.ctol, 'TolCon', Para.ctol,'Display','iter');
 opts = optimset(opts,'GradObj','on','GradConstr','on'); 
  if ra<1 
  xInit(2:5)=max([.01 .01 .01 .01],xInit(2:5));
  lb=[0 0 0 0 0];
  else
      lb=[0 -Inf -Inf -Inf -Inf];
  end
   ub=[Y(z) VSuperMax];
 [x,fval,exitflag,output,lambda,grad] = fmincon(@(x) GetValue(x,z,pi,c,Q,Para),xInit,[],[],[],[],lb,ub,@(x) PKConstraint(x,z,v,pi,Para),opts);
