function res=EUSol(z,v,pi,Para)
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
ZSize=Para.ZSize;
P=Para.P;
options = optimset('MaxFunEvals', 5000,'Display','off','TolFun',1e-5);
[alpha2,~,exitflag]=fzero(@(alpha) resCalcVEU(alpha,z,v,pi,Para),[.001 .99],options);
alpha1=1-alpha2;
PP=Para.P(:,:,1)*pi+Para.P(:,:,2)*(1-pi);
for i=1:ZSize
    for j=1:ZSize
        A(i,j)=-delta*PP(i,j);
    end
end

for i=1:ZSize
A(i,i)=1-delta*PP(i,i);
end


V1=inv(A)*u(alpha1*Y,ra);
V2=inv(A)*u(alpha2*Y,ra);
res.Cons=alpha1*Y(z);
res.VStar=V2;
res.QNewEU=V1(z);
res.V1=V1;
res.V2=V2;
res.alpha1=alpha1;
res.lambda=(alpha1/(1-alpha1))^(-ra);
res.exitflag=exitflag;
end
