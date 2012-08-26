% This program builds the grid for the spline approximation. To do this I
% check whether the stored grid points are ok by comparing the para struc
% for the stored points. If not I compute them as follows
% 1. the grid for Pi is simple linear selection of points in the interval 0
% to 1
% 2. the grid for V is obtained by computing the Robust utility of an agent
% who consumes alpha prop. of endowment every period. This involves solving
% the foll BME
% V_alpa(z,pi)=T2[u(alpha*y(z)+T1V_alpha(z^*,pi^*)]
% The program ComputeRU_alpha solves this by value function iterations
% -------------------------------------------------------------------------

% ---------CHECK THE STORED GRID POINTS------------------------------------
flagComputeGridPoints=1;
    GridPointsPath=[Para.DataPath 'GridPoints.mat'];
if exist(GridPointsPath)==2
GridPoints=load([Para.DataPath 'GridPoints.mat']);
flag = CheckPara(Para,GridPoints.Para);
if (flag==1 || flagOverrideInitialCheck==1) 
    disp('Using existing initial guess')
    flagComputeGridPoints=0;
    VMin=GridPoints.VMin;
    VMax=GridPoints.VMax;
    VSuperMax=GridPoints.VSuperMax;
end
end


%---------COMPUTE THE GRID POINTS------------------------------------------
% PI GRID
PiMin=0;
PiMax=1;
PiGridSize=Para.OrderOfApproximationPi*2;
PiGrid=linspace(PiMin,PiMax,PiGridSize);
%---------------------------------------------------------------------------



%--------- VGRID-----------------------------------------------------------
% SET THE MIN and MAX SHARE
% this is the minimum and max share to compute the grid
alphamin=.05;
alphamax=1-alphamin*1.5;
VGridSize=Para.OrderOfApproximationV*2;
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
save( [Para.DataPath 'GridPoints.mat'], 'VMin','VMax','Para', 'VSuperMax')
end


% ----- FUNCTIONAL SPACE---------------------------------------------------
% Define the functional space for value function approximation. This is
% done using the COMPECON lib routine -fundefn
% We have Q(z,p,v)

for z=1:Para.ZSize
Q(z) = fundefn(ApproxMethod,[OrderOfApproximationPi OrderOfApproximationV] ,[PiMin  VMin(z)],[PiMax VMax(z)]);
VGrid(z,:)=linspace(VMin(z),VMax(z),VGridSize);
end
disp('Using the following grid for V')
disp(VGrid)

%% STORE THE GRID IN THE PARA TRUC
Para.VMax=VMax;
Para.VMin=VMin;
Para.VGrid=VGrid;
Para.PiGrid=PiGrid;
Para.PiMin=PiMin;
Para.PiMax=PiMax;
Para.PiGridSize=PiGridSize;
Para.VGridSize=VGridSize;
Para.VSuperMax=VSuperMax;
GridSize=ZSize*VGridSize*PiGridSize;
Para.GridSize=GridSize;