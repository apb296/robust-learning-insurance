
alphamin=.15;
alphamax=1-alphamin;
% computes the EU solution for the initial guess 
VEUmin0=CalcVEU(alphamin,Para); 
VEUmax0=CalcVEU(alphamax,Para);
% computes the minimum and maximum lifetime utility from a fixed share of
% aggregate aggregate endowment for the multiolier preferences
options = optimset('MaxFunEvals', 5000*length(VEUmax0),'Display','off','TolFun',1e-5);

VMin=fsolve(@(V) CalcV(V,alphamin,Para),VEUmin0,options);
VMid1=fsolve(@(V) CalcV(V,alphamin+(alphamin+alphamax)/3,Para),VEUmin0,options);
VMid2=fsolve(@(V) CalcV(V,alphamin+(alphamin+alphamax)*2/3,Para),VEUmax0,options);
VMax=fsolve(@(V) CalcV(V,alphamax,Para),VEUmax0,options);


for z=1:Para.ZSize
Q(z) = fundefn('cheb',OrderOfApproximation,VMin(z),VMax(z),OrderOfSpline);
DerQ(z)=fundefn('cheb',OrderOfApproximation-1,VMin(z),VMax(z),OrderOfSpline);
%VGridtemp=linspace(VMin(z),VMid1(z),VGridInit*2);
%VGridtemp=[VGridtemp linspace(VMid1(z)*1.001,VMid2(z),VGridInit)];
%VGrid(z,:)=[VGridtemp linspace(VMid2(z)*1.001,VMax(z),VGridInit*2)];
VGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize);
VFineGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize*10);

end
Para.VGrid=VGrid;
Para.VGridSize=VGridSize;
% Set up the value functions for agent 1 for each state