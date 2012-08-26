% GetResults

     
clear all;
close all ;
clc
%matlabpool close force local
%matlabpool local 4
SetParaStruc;
flagOverrideInitialCheck=1;
BuildGrid;
VMax=Para.VMax;
VMin=Para.VMin;
i=Para.NIter-5;
Para.BenchMark=1;
SetPath;
citer=load( [Para.DataPath 'C_' num2str(i) '.mat']);
Para=citer.Para;
Q=citer.Q;
x0=citer.x0;
c=citer.c;
Para.BenchMark=1;

SetPath;
PiGridSize=Para.PiGridSize;
VGridSize=Para.VGridSize;
PiGrid=Para.PiGrid;
VGrid=Para.VGrid;
PiSize=Para.PiGridSize;


%[QNew Cons LambdaStar LambdaStarL VStar DelVStar DistPi_agent1 DistPi_agent2 ExitFlag MuCons SigmaCons Entropy_Z_Model1 Entropy_Z_Model2 Entropy_M PK MPR ConsStar ConsStarRatio MuDelVStar]=GetDiagnostics(c,Q,x0,Para,res);
  Para.VMax=VMax;Para.VMin=VMin;


%flagOverrideInitialCheck=1;
%EstimateVStar
m_draw0(1)=1;
z_draw0(1)=1;
V0(1)=VGrid(z_draw0(1),3);
pi_bayes0(1)=.5;
m_draw0(2)=2;
z_draw0(2)=3;
V0(2)=VGrid(z_draw0(2),13);
pi_bayes0(2)=.5;
Para.N=2000;
parfor k=1:2
    tic
SimulateV(m_draw0(k),z_draw0(k),V0(k),pi_bayes0(k),Para,c,Q)
toc
end

