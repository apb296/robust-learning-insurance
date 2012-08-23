% This solves the infinite horizon no learning case
clc
clear all
close all
addpath(genpath('C:\Program Files\MATLAB\R2010b\toolbox\compecon2011'))
%addpath(genpath('/Applications/MATLAB_R2011a_Student.app/toolbox/compecon2011/'))
%matlabpool open

% Parameters for the Model
SetParaStruc;
% Grid for State-Space
BuildGrid;
flagDisp=1;

for z=1:Para.ZSize
for v=1:VGridSize
res=EUSol(z,VGrid(z,v),Para);
EU(z,v)=res.V1(z);
DerEU(z,v)=-res.lambda;
alpha1(z,v)=res.alpha1;
end


end
plot(alpha1')
figure
plot(DerEU')
%InitializeC;

