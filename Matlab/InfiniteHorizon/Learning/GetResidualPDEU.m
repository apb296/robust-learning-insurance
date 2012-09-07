function [ res ] = GetResidualPDEU( pdguess,Para,m )
% This function solves the PD ratio recursively for model m in the expected
% utility case


delta=Para.delta;
P=Para.P;
ra=Para.RA;
Y=Para.Y;

pdguessforallz(1)=pdguess(1);
pdguessforallz(2)=pdguess(1);
pdguessforallz(3)=pdguess(2);
pdguessforallz(4)=pdguess(2);

for z=1:Para.ZSize
    for zstar=1:Para.ZSize
        MRS(zstar)=(Y(zstar)/Y(z))^(-ra);
        GrowthRateY(zstar)=Y(zstar)/Y(z);
        
    end
    RHS(z)=sum(delta*P(z,:,m).*MRS.*(pdguessforallz.*GrowthRateY+GrowthRateY));
    resforallz(z)=pdguessforallz(z)-RHS(z);
    
end
res(1)=resforallz(1)+resforallz(2);
res(2)=resforallz(3)+resforallz(4);
