
function res =resCalcVEU(alpha,z,v,pi,Para)
ra=Para.RA;
Y=Para.Y;
delta=Para.delta;
ZSize=Para.ZSize;
P=Para.P;
PP=Para.P(:,:,1)*pi+Para.P(:,:,2)*(1-pi);
for i=1:ZSize
    for j=1:ZSize
        A(i,j)=-delta*PP(i,j);
    end
end

for i=1:ZSize
A(i,i)=1-delta*PP(i,i);
end

VEU=A\u(alpha*Y,ra);
res=VEU(z)-v;