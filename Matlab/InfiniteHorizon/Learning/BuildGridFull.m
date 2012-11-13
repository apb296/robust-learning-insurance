function [VMax,VMin,VGrid,PiGrid,PiMin,PiMax,PiGridSize,VGridSize,VSuperMax,Q]=BuildGridFull(Para)

% This program builds the grid for the spline approximation. 
% 1. the grid for Pi is simple linear selection of points in the interval 0
% to 1
% 2. the grid for V is obtained by computing the Robust utility of an agent
% who consumes the entire endowment every period. This involves solving
% the foll BME
% V(z,pi)=T2[u(y(z)+T1V(z^*,pi^*)]
% The program ComputeRU_alpha solves this by value function iterations
% -------------------------------------------------------------------------


%---------COMPUTE THE GRID POINTS------------------------------------------
% PI GRID
PiMin=0;
PiMax=1;
PiGridSize=Para.OrderOfApproximationPi*Para.PiGridDensityFactor;
PiGrid=linspace(PiMin,PiMax,PiGridSize);
%---------------------------------------------------------------------------



%--------- VGRID-----------------------------------------------------------
% SET THE MIN and MAX SHARE
% this is the minimum and max share to compute the grid
VGridSize=Para.OrderOfApproximationV*Para.VGridDensityFactor;
%---------------------------------------------------------------------------

% %% EU SOLUTION
% % Computes the EU solution for the initial guess 
% VEUmin0=CalcVEU(alphamin,Para); 
% VEUmax0=CalcVEU(alphamax,Para);
% 

%% RU GRIDPOINTS
% computes the minimum and maximum lifetime utility from a fixed share of
% aggregate aggregate endowment for the multiplier preferences
if flagComputeGridPoints==1
for z=1:Para.ZSize
    disp('...Computing GridPoints for z=')
    disp(z)
VMin(z)=max(ComputeRU_alpha(alphamin,z,PiMin,Para),ComputeRU_alpha(alphamin,z,PiMax,Para));
VMax(z)=min(ComputeRU_alpha(alphamax,z,PiMin,Para),ComputeRU_alpha(alphamax,z,PiMax,Para));
VSuperMax(z)=max(ComputeRU_alpha(1,z,PiMin,Para),ComputeRU_alpha(1,z,PiMax,Para));
end

% ----- STORE THE GRIDPOINTS-----------------------------------------------
% This avoids computing them incase the key parameters are unchanged
end


% ----- FUNCTIONAL SPACE---------------------------------------------------
% Define the functional space for value function approximation. This is
% done using the COMPECON lib routine -fundefn
% We have Q(z,p,v)

for z=1:Para.ZSize
Q(z) = fundefn(Para.ApproxMethod,[Para.OrderOfApproximationPi Para.OrderOfApproximationV] ,[PiMin  VMin(z)],[PiMax VMax(z)]);
VGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize);
end
disp('Using the following grid for V')
disp(VGrid)
save( [Para.DataPath 'GridPoints.mat'], 'VMin','VMax','Para', 'VSuperMax')


