function [ cNew ] = FitConcaveValueFunctionWithDerivativeInformation(V,VNew,x,ShapeTestPoints,Derivatives,g)
%FitConcaveValueFunction : This function updates the coeffecients using a
%least square fit imposing concavity with respect to  at randomly
%choosen 20% points
%   Detailed explanation goes here
[cguess]=funfitxy(V,x,VNew);
LSRes=@(c) (1-g)*(sum((funeval(c,V,x)-VNew).^2))^.5+g*(sum((funeval(c,V,x(end-5:end),1)-Derivatives(end-5:end)).^2))^.5;
NumShapeTestPoints=size(ShapeTestPoints,1);
for ctr=1:NumShapeTestPoints
sc=funbasx(V,ShapeTestPoints(ctr,:),[2],'expanded');
mc=funbasx(V,ShapeTestPoints(ctr,:),[1],'expanded');
ShapeConstraints(ctr,:)=sc.vals{1};
MonCons(ctr,:)=mc.vals{1};
end

A=[ShapeConstraints;MonCons];
b=zeros(NumShapeTestPoints*2,1);
%Aeq=[MonCons];
%beq=[Derivatives];
Aeq=[];
beq=[];
opts = optimset('Display','iter');    
[cNew ,fval,exitflag] = ktrlink(@(c) LSRes(c),cguess,A,b,Aeq,beq,[],[],[],opts);

cNew=cNew';


end

