SetParaStruc
Para.c_offset=.005*Para.y;
Para.StoreFileName='PrivateInformationNoAmb.mat';
MainBellman(Para)
MainSimulations


SetParaStruc
Para.StoreFileName='PrivateInformationHighAmb.mat';
Para.c_offset=.005*Para.y;
Para.Theta=ones(2,2);
MainBellman(Para)
MainSimulations



Para.StoreFileName='PrivateInformationMedAmb.mat';
Para.Theta=ones(2,2)*10;
MainBellman(Para)
MainSimulations


SetParaStruc
Para.StoreFileName='PrivateInformationVeryHighAmb.mat';
Para.Theta=ones(2,2)*.5;
MainBellman(Para)
MainSimulations

SetParaStruc
Para.ra=1;
Para.Theta=ones(2,2)*10000000;
Para.StoreFileName='PrivateInformationNoAmbHighRiskAversion.mat';
MainBellman(Para)
MainSimulations


SetParaStruc
Para.ra=1;
Para.Theta=ones(2,2);
Para.StoreFileName='PrivateInformationAmbHighRiskAversion.mat';
MainBellman(Para)
MainSimulations


SetParaStruc
Para.beta=.95;
Para.StoreFileName='PrivateInformationNoAmbHighDelta.mat';
MainBellman(Para)
MainSimulations



NumSim=10000;
rHist=rand(NumSim+1,1);
SetParaStruc
Para.StoreFileName='PrivateInformationNoAmb.mat';
MainSimulations

Para.StoreFileName='PrivateInformationHighAmb.mat';
MainSimulations


SetParaStruc
Para.StoreFileName='PrivateInformationNoAmbNoStateRisk.mat';
MainBellman(Para)




NumSim=5000;
SetParaStruc
Para.Theta=[10000000 10000000;1 1];
Para.StoreFileName='PrivateInformationHeteroTheta.mat';
MainBellman(Para)
MainSimulations



SetParaStruc
Para.ra=1;
Para.c_offset=.005*Para.y; % lowest consumption
Para.Theta=ones(2,2)*10000000;
Para.StoreFileName='PrivateInformationNoAmbHighRiskAversion.mat';
MainBellman(Para)
MainSimulations






clear all
NumSim=50000;
rHist=rand(NumSim+1,1);
Para.StoreFileName='PrivateInformationVeryHighAmb.mat';
MainSimulationsUsingLinearInterpolation
Para.StoreFileName='PrivateInformationNoAmb.mat';
MainSimulationsUsingLinearInterpolation

clear all
NumSim=100000;
rHist=rand(NumSim+1,1);
Para.StoreFileName='PrivateInformationNoAmbHighRiskAversion.mat';
MainSimulationsUsingLinearInterpolation





clear all
NumSim=10000;
rHist=rand(NumSim+1,1);
Para.StoreFileName='PrivateInformationHighAmb.mat';
MainSimulationsUsingLinearInterpolation
Para.StoreFileName='PrivateInformationNoAmb.mat';
MainSimulationsUsingLinearInterpolation

