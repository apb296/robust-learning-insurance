% This script plots the Simulation outcomes
close all
clear all
clc
SimDataAmb=load('Data/SimDataAmb.mat');
SimDataNoAmb=load('Data/SimDataNoAmb.mat');

mkdir('Graphs')
PlotParams.T=100;

%  - ConsumptionShares -

PlotParams.YLabel='$\eta_1$';
PlotParams.Title = 'Agent1ConsumptionShare';
PlotParams.PlotPath='Graphs/Agent1ConsumptionShare';
XAmb.Data=SimDataAmb.ConsRatioAgent1Hist;
XNoAmb.Data=SimDataNoAmb.ConsRatioAgent1Hist;
PlotSimulationForX(PlotParams,XAmb,XNoAmb)


%  - Continuation Values -

PlotParams.YLabel='$V$';
PlotParams.Title = 'ContinuationValues';
PlotParams.PlotPath='Graphs/ContinuationValues';
XAmb.Data=SimDataAmb.VHist;
XNoAmb.Data=SimDataNoAmb.VHist;
PlotSimulationForX(PlotParams,XAmb,XNoAmb)




%  - MPR -

PlotParams.YLabel='MPR';
PlotParams.Title = 'MPR';
PlotParams.PlotPath='Graphs/MPR';
XAmb.Data=SimDataAmb.MPRHist;
XNoAmb.Data=SimDataNoAmb.MPRHist;
PlotSimulationForX(PlotParams,XAmb,XNoAmb)




%  - Entropy Agent 1 - Entropy Agent 2 -

PlotParams.YLabel='DiffEntropyAgent1';
PlotParams.Title = 'DiffEntropyAgent1';
PlotParams.PlotPath='Graphs/DiffEntropy';
XAmb.Data=SimDataAmb.Emlogm_distmarg_agent1Hist-SimDataAmb.Emlogm_distmarg_agent2Hist;
XNoAmb.Data=SimDataNoAmb.Emlogm_distmarg_agent1Hist-SimDataNoAmb.Emlogm_distmarg_agent2Hist;;
PlotSimulationForX(PlotParams,XAmb,XNoAmb)

