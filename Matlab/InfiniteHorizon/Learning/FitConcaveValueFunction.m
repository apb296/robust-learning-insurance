function [ cNew ] = FitConcaveValueFunction(V,VNew,x,ShapeTestPoints)
%FitConcaveValueFunction : This function updates the coeffecients using a
%least square fit imposing concavity with respect to  at randomly
%choosen 20% points
%   Detailed explanation goes here
[cguess]=funfitxy(V,x,VNew);
LSRes=@(c) (sum((funeval(c,V,x)-VNew).^2))^.5;
NumShapeTestPoints=size(ShapeTestPoints,1);
for ctr=1:NumShapeTestPoints
sc=funbasx(V,ShapeTestPoints(ctr,:),[0 2],'expanded');
mc=funbasx(V,ShapeTestPoints(ctr,:),[0 1],'expanded');
ShapeConstraints(ctr,:)=sc.vals{1};
MonCons(ctr,:)=mc.vals{1};
end

A=[ShapeConstraints;MonCons];
b=zeros(NumShapeTestPoints*2,1);
%A=[];
%b=[];
Aeq=[];
beq=[];
opts = optimset('Algorithm', 'interior-point', 'Display','off');    
[cNew ,fval,exitflag] = fmincon(@(c) LSRes(c),cguess,A,b,[],[],[],[],[],opts);

cNew=cNew';


end

