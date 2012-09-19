function res=EUSol(y,v,Para)
ra=Para.gamma;
Y=Para.Y;
delta=Para.delta;
YSize=length(Y);
P=(Para.P1+Para.P2)/2;
options = optimset('MaxFunEvals', 5000,'Display','off','TolFun',1e-7);
alpha2=fsolve(@(alpha) resCalcVEU(alpha,y,v,Para),.5,options);
VMax=max(Para.VGrid');
VMin=min(Para.VGrid');
QMax=Para.QMax;
% check if alpha2 <1
alpha2=max(min(alpha2,.9999),1-.99999);
alpha1=1-alpha2;

for i=1:YSize
    for j=1:YSize
        A(i,j)=-delta*P(i,j);
    end
end

for i=1:YSize
A(i,i)=1-delta*P(i,i);
end

V1=inv(A)*u(alpha1*Y,ra);
V2=inv(A)*u(alpha2*Y,ra);
res.V1=V1;
res.V2=V2;
%res.V1=max(min(V1',QMax),VMin);
%res.V2=max(min(V2',VMax),VMin);
res.alpha1=alpha1;
end
