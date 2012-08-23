% To build the grid for v. I use the following procedure - Pick a two values for alpha  - alphamin
% and alphamax . Compute the robust utility of the  agent
% who consumes alpha share of the aggregate endowment given z_0=z. The grid
% is defined as some interpolation of [V_{alphamin}(z),V_{alphamax}(z)].
% The program CalcV does this task. CalcVEU is does is to EU case and we
% can use this as initial conditions for CalcV.


% Set up the minimum and maximum share of the aggregate endowment
alphamin=.05;
alphamax=(1-alphamin*1.5);
%alphamax=.8;


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
for z=1:Para.ZSize
Q(z) = fundefn(ApproxMethod,OrderOfApproximationV,VMin(z),VMax(z));
VGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize);
end
Para.VGrid=VGrid;
Para.VGridSize=VGridSize;
Para.VSuperMax=VSuperMax;
GridSize=Para.VGridSize*ZSize;
Para.GridSize=GridSize;

