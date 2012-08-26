
function VEU =CalcVEU(alpha,Para)

Y=Para.Y;
delta=Para.delta;
ZSize=Para.ZSize;
P=Para.P;
MSize=Para.MSize;
PM=zeros(ZSize,ZSize);
ra=Para.RA;
for m=1:MSize
    PM=PM+P(:,:,m).*.5;
end

    for i=1:ZSize
    for j=1:ZSize
        A(i,j)=-delta*PM(i,j);
    end
    end

for i=1:ZSize
A(i,i)=1+A(i,i);
end

VEU=(inv(A)*u(alpha*Y,ra));

