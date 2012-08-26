function cNew=ParallelCoeff_test(z,c,Q,xx,Para)

%addpath(genpath(Para.CompEconPath));
PiGridSize=Para.PiGridSize;
VGridSize=Para.VGridSize;
PiGrid=Para.PiGrid;
VGrid=Para.VGrid;
ctr=1;
%addpath(genpath(Para.CompEconPath));
ZSize=Para.ZSize;
delta=Para.delta;
Y=Para.Y;
ctol=Para.ctol;
i=1;
ra=Para.RA;
%Guess the starting value for FOC using the solution for the NoLearning
%case. We use the weighted average of the solutions for both models using
%the priors


xInit=xx(i,3:end);
%options = optimset('MaxFunEvals', 5000*length(x0),'Display','off','TolFun',ctol);

  x=xInit; 
  %addpath(genpath(Para.CompEconPath));
cons=x(1);
    der_u(cons,ra)
   