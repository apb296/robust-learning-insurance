SetParaStruc
Para.pl=[.75 .25]; % probability of low shock
Para.ph=[.25 .75]; % probability of high shock
Para.StoreFileName='PrivateInformationHeterogenousModels.mat';
MainBellman(Para)

SetParaStruc
Para.pl=[.75 .25]; % probability of low shock
Para.ph=[.25 .75]; % probability of high shock
Para.StoreFileName='PrivateInformationHeterogenousModels2.mat';
MainBellman(Para)


SetParaStruc
Para.Theta=ones(2,2)*.25;
Para.StoreFileName='PrivateInformationVeryHighAmb2.mat';
MainBellman(Para)


SetParaStruc
Para.Theta=ones(2,2)*.25;
Para.StoreFileName='PrivateInformationVeryHighAmbWithoutCons.mat';
MainBellman(Para)
