
function VEU =CalcVEU(alpha,Para)

Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
ra=Para.RA;
for i=1:ZSize
    for j=1:ZSize
        A(i,j)=-delta*P(i,j,m_true);
    end
end

for i=1:ZSize
A(i,i)=1+A(i,i);
end

VEU=inv(A)*u(alpha*Y,ra);