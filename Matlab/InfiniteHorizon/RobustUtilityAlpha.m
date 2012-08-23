
% This program computes the Robust Utility for an agent who consumes a
% fixed proportion of endowment - alpha

PiMin=.0;
PiMax=1;
PiGridSize=10;
OrderOfApproximation=5;
OrderOfSpline=5;
PiGrid=linspace(PiMin,PiMax,PiGridSize);

% Define the function space structure 

for z=1:ZSize
    Q_alpha(z) = fundefn('cheb',OrderOfApproximation,PiMin(z),PiMax(z),OrderOfSpline);
end

% Initialize

m_true=Para.m_true;

