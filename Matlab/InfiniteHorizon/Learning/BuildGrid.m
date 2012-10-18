function [VMax,VMin,VGrid,PiGrid,PiMin,PiMax,PiGridSize,VGridSize,VSuperMax,Q]=BuildGrid(Para,alphamin,alphamax)

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
if exist(GridPointsPath,'file')==2
GridPoints=load([Para.DataPath 'GridPoints.mat']);
flag = CheckPara(Para,GridPoints.Para);
if (flag==1) 
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
    
    [Coeff_alphamin,Q_alphamin]=ComputeRU_alpha(alphamin,Para,linspace(0,1,20),Para.PiGridDensityFactor,25);
    
    [Coeff_alphamax,Q_alphamax]=ComputeRU_alpha(alphamax,Para,linspace(0,1,20),Para.PiGridDensityFactor,25);
    
    [Coeff_1,Q_1]=ComputeRU_alpha(1,Para,linspace(0,1,20),Para.PiGridDensityFactor,25);
    
    
 for z=1:Para.ZSize
    disp('...Computing GridPoints for z=')
    disp(z)
%VMin(z)=max(ComputeRU_alpha(alphamin,z,PiMin,Para),ComputeRU_alpha(alphamin,z,PiMax,Para));
if alphamin==0
    VMin(z)=0;
else
    
[pitilde,MinusVMin] = fminbnd(@(pi) -funeval(Coeff_alphamin(z,:)',Q_alphamin(z),pi), 0,1)
VMin(z)=  -MinusVMin;
end
%VMax(z)=min(ComputeRU_alpha(alphamax,z,PiMin,Para),ComputeRU_alpha(alphamax,z,PiMax,Para));
[pitilde,VMax(z)] = fminbnd(@(pi) funeval(Coeff_alphamax(z,:)',Q_alphamax(z),pi), 0,1);
[pitilde,VSuperMax(z)] = fminbnd(@(pi) funeval(Coeff_1(z,:)',Q_1(z),pi), 0,1);

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


