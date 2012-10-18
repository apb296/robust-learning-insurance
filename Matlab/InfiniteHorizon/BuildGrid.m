
function [Q,VGrid,VSuperMax,GridSize]=BuildGrid(Para,alphamin,alphamax)
% To build the grid for v. I use the following procedure - Pick a two values for alpha  - alphamin
% and alphamax . Compute the robust utility of the  agent
% who consumes alpha share of the aggregate endowment given z_0=z. The grid
% is defined as some interpolation of [V_{alphamin}(z),V_{alphamax}(z)].
% The program CalcV does this task. CalcVEU is does is to EU case and we
% can use this as initial conditions for CalcV.

ZSize=Para.ZSize;
VGridSize=Para.VGridSize;



% computes the EU solution for the initial guess 
VEUmin0=CalcVEU(alphamin,Para); 
VEUmax0=CalcVEU(alphamax,Para);
VEUSupermax0=CalcVEU(1,Para);
% computes the minimum and maximum lifetime utility from a fixed share of
% aggregate aggregate endowment for the multiplier preferences
options = optimset('MaxFunEvals', 5000*length(VEUmax0),'Display','off','TolFun',1e-5);
VMin=fsolve(@(V) CalcV(V,alphamin,Para),VEUmin0,options);
VMid1=fsolve(@(V) CalcV(V,alphamin+(alphamin+alphamax)/3,Para),VEUmin0,options);
VMid2=fsolve(@(V) CalcV(V,alphamin+(alphamin+alphamax)*2/3,Para),VEUmax0,options);
VMax=fsolve(@(V) CalcV(V,alphamax,Para),VEUmax0,options);
VSuperMax=fsolve(@(V) CalcV(V,1,Para),VEUSupermax0,options);

% Set up the value functions for agent 1 for each state
for z=1:ZSize
Q(z) = fundefn(Para.ApproxMethod,Para.OrderOfApproximationV,VMin(z),VMax(z));
VGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize);
end
VGrid=VGrid;
VGridSize=VGridSize;
VSuperMax=VSuperMax;
GridSize=VGridSize*ZSize;
end

