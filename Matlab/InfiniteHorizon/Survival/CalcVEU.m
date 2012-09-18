
function VEU =CalcVEU(alpha,Para)

Y=Para.Y;
delta=Para.delta;
YSize=length(Para.Y);
P=(Para.P1+Para.P2)/2;
gamma=Para.gamma;
for i=1:YSize
    for j=1:YSize
        A(i,j)=-delta*P(i,j);
    end
end

for i=1:YSize
A(i,i)=1+A(i,i);
end

VEU=inv(A)*u(alpha*Y,gamma);