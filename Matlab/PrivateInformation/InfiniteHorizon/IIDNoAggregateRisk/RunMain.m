NumSim=50000;
rHist=rand(NumSim+1,1);
SetParaStruc
Para.Theta=ones(2,2)*10000000;
Para.vGridSize=25; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=20; % order of approximation
Para.InitializeDataFile='PrivateInformationNoAmb.mat';
Para.StoreFileName='PrivateInformationNoAmb.mat';
Para.c_offset=.005*Para.y;  
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation


clear all
SetParaStruc
Para.vGridSize=25; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=20; % order of approximation
Para.Theta=ones(2,2);
Para.StoreFileName='PrivateInformationHighAmb.mat';
Para.c_offset=.005*Para.y;  
Para.MaxIter=250;
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation


SetParaStruc
Para.vGridSize=20; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=10; % order of approximation
Para.Delta=Para.y*.3;
Para.Theta=ones(2,2)*10000000;
Para.StoreFileName='PrivateInformationNoAmbHighDelta.mat';
Para.c_offset=.005*Para.y;  
Para.MaxIter=25;
MainBellman(Para)
Para.MaxIter=250;
Para.InitializeDataFile='PrivateInformationNoAmbHighDelta.mat';
Para.flagInitializeCoeffWithExistingData=1;
Para.vGridSize=40; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=25; % order of approximation
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation


SetParaStruc
Para.vGridSize=15; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=10; % order of approximation
Para.Delta=Para.y*.1;
Para.Theta=ones(2,2)*10000000;
Para.StoreFileName='PrivateInformationNoAmbLowDelta.mat';
Para.c_offset=.005*Para.y;  
Para.MaxIter=25;
MainBellman(Para)
Para.MaxIter=250;
Para.InitializeDataFile='PrivateInformationNoAmbLowDelta.mat';
Para.flagInitializeCoeffWithExistingData=1;
Para.vGridSize=40; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=25; % order of approximation
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation


SetParaStruc
Para.vGridSize=75; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=50; % order of approximation
Para.Theta=ones(2,2)*10000000;
Para.flagInitializeCoeffWithExistingData=1;
Para.InitializeDataFile='PrivateInformationNoAmb.mat';
Para.StoreFileName='PrivateInformationNoAmbFinerGrid.mat';
Para.c_offset=.005*Para.y;  
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation






SetParaStruc
Para.Delta=Para.y*.3;
Para.vGridSize=15; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=10; % order of approximation
Para.Theta=ones(2,2);
Para.StoreFileName='PrivateInformationHighAmbHighDelta.mat';
Para.c_offset=.005*Para.y;  
Para.MaxIter=25;
MainBellman(Para)
Para.MaxIter=250;
Para.InitializeDataFile='PrivateInformationHighAmbHighDelta.mat';
Para.flagInitializeCoeffWithExistingData=1;
Para.vGridSize=40; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=25; % order of approximation
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation














SetParaStruc
Para.vGridSize=15; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=10; % order of approximation
Para.Theta=ones(2,2)*10;
Para.StoreFileName='PrivateInformationMedAmb.mat';
Para.c_offset=.005*Para.y;  
Para.MaxIter=25;
MainBellman(Para)
Para.MaxIter=250;
Para.InitializeDataFile='PrivateInformationMedAmb.mat';
Para.flagInitializeCoeffWithExistingData=1;
Para.vGridSize=40; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=25; % order of approximation
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation





SetParaStruc
Para.vGridSize=15; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=10; % order of approximation
Para.Theta=ones(2,2)*100;
Para.StoreFileName='PrivateInformationLowAmb.mat';
Para.c_offset=.005*Para.y;  
Para.MaxIter=25;
MainBellman(Para)
Para.MaxIter=250;
Para.InitializeDataFile='PrivateInformationLowAmb.mat';
Para.flagInitializeCoeffWithExistingData=1;
Para.vGridSize=40; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=25; % order of approximation
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation


SetParaStruc
Para.vGridSize=15; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=10; % order of approximation
Para.Theta=ones(2,2)*.5;
Para.StoreFileName='PrivateInformationVeryHighAmb.mat';
Para.c_offset=.005*Para.y;  
Para.MaxIter=25;
MainBellman(Para)
Para.MaxIter=250;
Para.InitializeDataFile='PrivateInformationVeryHighAmb.mat';
Para.flagInitializeCoeffWithExistingData=1;
Para.vGridSize=40; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=25; % order of approximation
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation


SetParaStruc
Para.Theta=ones(2,2)*10000000;
Para.flagInitializeCoeffWithExistingData=0;
Para.vGridSize=25; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=20; % order of approximation
Para.StoreFileName='PrivateInformationNoAmbExp.mat';
Para.c_offset=.005*Para.y;  
MainBellman(Para)
%MainSimulationsUsingLinearInterpolation

SetParaStruc
Para.Theta=ones(2,2)*.25;
Para.flagInitializeCoeffWithExistingData=1;
Para.InitializeDataFile='PrivateInformationAmbExp.mat';
Para.vGridSize=50; % number of points on the grid
Para.ApproxMethod='spli'; % basis polynomials
Para.OrderOfAppx=30; % order of approximation
Para.StoreFileName='PrivateInformationAmbExp.mat';
Para.c_offset=.005*Para.y;  
MainBellman(Para)
%%MainSimulationsUsingLinearInterpolation

