
NumSim=150000;
NumStarts=8;
NumPaths=100;
Para.StoreFileName='PrivateInformationNoAmb.mat';
ExitTime
save('Data/PrivateInformationNoAmbExitTime.mat','TSim','ET')
Para.StoreFileName='PrivateInformationHighAmb.mat';
ExitTime
save('Data/PrivateInformationHighAmbExitTime.mat','TSim','ET')
