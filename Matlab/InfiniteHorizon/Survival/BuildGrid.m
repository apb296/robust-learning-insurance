
function [Q,VGrid,QMax,VMax]=BuildGrid(Para)


VGridSize=Para.VGridSize;

% computes the EU solution for the initial guess 
VEUSupermax0=CalcVEU(1,Para);
% computes the minimum and maximum lifetime utility from a fixed share of
% aggregate aggregate endowment for the multiplier preferences
options = optimset('MaxFunEvals', 5000,'Display','off','TolFun',1e-5);
VMax=fsolve(@(V) CalcV(V,1,Para,2),VEUSupermax0,options);
QMax=fsolve(@(V) CalcV(V,1,Para,1),VEUSupermax0,options);

% Set up the value functions for agent 1 for each state
for y=1:length(Para.Y)
Q(y) = fundefn(Para.ApproxMethod,Para.OrderOfApproximationV,0,VMax(y));
VGrid(y,:)=linspace(0,VMax(y)*Para.MaxGridAdjustment,VGridSize);
% Build a dense grid near VMax
%Vgrid1=linspace(0,VMax(y)*.5,VGridSize);
%Vgrid2=linspace(VMax(y)*.5,VMax(y),round(VGridSize)/2);
% Vgrid3=linspace((VMax(y)*3/4)*1.05,(VMax(y)),VGridSize-length([Vgrid1 Vgrid2]));
%VGrid(y,:)=[Vgrid1 Vgrid2];
end
end

