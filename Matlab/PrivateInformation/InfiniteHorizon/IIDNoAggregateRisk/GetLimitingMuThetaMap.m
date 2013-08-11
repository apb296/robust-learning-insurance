

% Set default parameters
clear all
close all

if matlabpool('size')==0
matlabpool open local
end
SetParaStruc

Para.beta=.9;
Para.ra=.5;
Para.y=10; % Aggregate output
Para.sl=.25; % low share
Para.sh=.75; % high share
Para.Delta=Para.y*(Para.sh-Para.sl); % Amount you can stead
Para.vGridSize=105; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=100; % order of approximation
Para.InitializeDataFile='PrivateInformationAmbtemp.mat';
Para.StoreFileName='PrivateInformationAmbtemp.mat';
Para.c_offset=.0005*Para.y;  
Para.MaxIter=15;



% Make thetaGrid
thetaMin=.8;
thetaMax=20;
thetaGridSize=10;
thetaGrid=linspace(thetaMin,thetaMax,thetaGridSize);

for theta_ind=1:thetaGridSize
Param(theta_ind)=Para;
Param(theta_ind).Theta=ones(2,2)*thetaGrid(theta_ind);
Param(theta_ind).StoreFileName=['PrivateInformationAmb' theta_ind '.mat'];
end

parfor theta_ind=1:thetaGridSize
MainBellman(Param(theta_ind))   
[LimitingGrowthRate(theta_ind),LimitingMu(theta_ind),MuApprox(theta_ind)]=ComputeLimitingMu(Param(theta_ind));
end

