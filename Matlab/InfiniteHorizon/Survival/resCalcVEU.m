
function res =resCalcVEU(alpha,z,v,Para)
% This function computes the residual for alpha (v,z). 

% -- Recover the parameters ----
Y=Para.Y;
YSize=length(Y);
delta=Para.delta;
P=(Para.P1+Para.P2)/2;
ra=Para.gamma;

% ------------------------------

% -- Compute the matrix A ----
for i=1:YSize
    for j=1:YSize
        A(i,j)=-delta*P(i,j);
    end
end
% Fix the diagnonal
for i=1:YSize
A(i,i)=1-delta*P(i,i);
end

% ------------------------------

% -- Compute the residual error in Promise keeping ----

VEU=A\u(alpha*Y,ra);
res=VEU(z)-v;
