
function [Q,VGrid]=BuildGrid(Para)


VGridSize=Para.VGridSize;

% computes the EU solution for the initial guess 
VEUSupermax0=CalcVEU(1,Para);
% computes the minimum and maximum lifetime utility from a fixed share of
% aggregate aggregate endowment for the multiplier preferences
options = optimset('MaxFunEvals', 5000,'Display','off','TolFun',1e-5);
VMax=fsolve(@(V) CalcV(V,1,Para),VEUSupermax0,options);

% Set up the value functions for agent 1 for each state
for y=1:length(Para.Y)
Q(y) = fundefn(Para.ApproxMethod,Para.OrderOfApproximationV,0,VMax(y));
VGrid(y,:)=linspace(0,VMax(y),VGridSize);
end
VGrid=VGrid;
end

