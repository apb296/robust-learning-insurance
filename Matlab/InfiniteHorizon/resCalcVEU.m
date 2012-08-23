
function res =resCalcVEU(alpha,z,v,Para)
% This function computes the residual for alpha (v,z). 

% -- Recover the parameters ----
Y=Para.Y;
delta=Para.delta;
m_true=Para.m;
ZSize=Para.ZSize;
P=Para.P;
ra=Para.RA;

% ------------------------------

% -- Compute the matrix A ----
for i=1:ZSize
    for j=1:ZSize
        A(i,j)=-delta*P(i,j,m_true);
    end
end
% Fix the diagnonal
for i=1:ZSize
A(i,i)=1-delta*P(i,i,m_true);
end

% ------------------------------

% -- Compute the residual error in Promise keeping ----

VEU=A\u(alpha*Y,ra);
res=VEU(z)-v;
