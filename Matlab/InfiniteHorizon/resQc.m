function resQc=resQc(cons,der_c,z,v,DerQ,Para)
Y=Para.Y;
ra=Para.RA;
VGrid=Para.VGrid;
if cons<0
    resQc=100;
elseif cons>Y(z)
    resQc=100;
else
lambda = -funeval(der_c(z,:)',DerQ(z),VGrid(z,v));

%resQc=(cons/(Y(z)-cons))^(-ra)-lambda;
resQc=(der_u(cons)/der_u(Y(z)-cons))-lambda;
end
end
